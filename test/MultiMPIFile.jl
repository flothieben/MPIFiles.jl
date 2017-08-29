fnMeasBruker = "measurement_Bruker"
fnMeasMultiV2 = "measurement_multi_V2.mdf"


measBruker = MultiMPIFile([fnMeasBruker,fnMeasBruker,fnMeasBruker])

saveasMDF(fnMeasMultiV2, measBruker)

mdfv2 = MPIFile(fnMeasMultiV2)
@test typeof(mdfv2) == MDFFileV2

for mdf in (measBruker,mdfv2)
  println("Test $mdf")
  @test studyName(mdf) == "Wuerfelphantom_Wuerfelphantom_1"
  @test studyNumber(mdf) == 1
  @test studyDescription(mdf) == "n.a."

  @test experimentName(mdf) == "fuenf (E18)"
  @test experimentNumber(mdf) == 18
  @test experimentDescription(mdf) == "fuenf (E18)"
  @test experimentSubject(mdf) == "Wuerfelphantom"
  @test experimentIsSimulation(mdf) == false
  @test experimentIsCalibration(mdf) == false

  @test scannerFacility(mdf) == "Universitätsklinikum Hamburg Eppendorf"
  @test scannerOperator(mdf) == "nmrsu"
  @test scannerManufacturer(mdf) == "Bruker/Philips"
  @test scannerName(mdf) == "Preclinical MPI System"
  @test scannerTopology(mdf) == "FFP"

  @test tracerName(mdf) == ["Resovist"]
  @test tracerBatch(mdf) == ["0"]
  @test tracerVendor(mdf) == ["n.a."]
  @test tracerVolume(mdf) == [0.0]
  @test tracerConcentration(mdf) == [0.5]
  @test tracerInjectionTime(mdf) == [DateTime("2015-09-15T11:17:23.011")]

  @test acqStartTime(mdf) == DateTime("2015-09-15T11:17:23.011")
  @test acqGradient(mdf)[:,1] == [-1.25; -1.25; 2.5]
  @test acqFramePeriod(mdf) == 6.528E-4
  @test acqNumPeriods(mdf) == 3
  @test acqNumPeriods(mdf) == 3
  @test size(acqOffsetFieldShift(mdf)) == (3,3)

  @test dfNumChannels(mdf) == 3
  @test dfWaveform(mdf) == "sine"
  @test dfStrength(mdf)[:,:,1] == [0.014 0.014 0.0]
  @test dfPhase(mdf)[:,:,1] == [1.5707963267948966 1.5707963267948966 1.5707963267948966]
  @test dfBaseFrequency(mdf) == 2500000.0
  @test dfDivider(mdf)[:,1] == [102; 96; 99]
  @test dfPeriod(mdf) == 6.528E-4

  @test rxNumChannels(mdf) == 3
  @test rxBandwidth(mdf) == 1250000.0
  @test rxNumSamplingPoints(mdf) == 1632
  @test rxDataConversionFactor(mdf) == repeat([1.0, 0.0], outer=(1,rxNumChannels(mdf)))
  @test acqNumAverages(mdf) == 1

  @test acqNumFrames(mdf) == 500
  @test size( measData(mdf) ) == (1632,3,3,500)

  N = acqNumFrames(mdf)

  @test size(getMeasurements(mdf, numAverages=1,
              spectralLeakageCorrection=false, fourierTransform=false)) == (1632,3,3,500)

  @test size(getMeasurements(mdf, numAverages=10,
              spectralLeakageCorrection=false, fourierTransform=false)) == (1632,3,3,50)

  @test size(getMeasurements(mdf, numAverages=10, frames=1:100,
              fourierTransform=true)) == (817,3,3,10)

  @test size(getMeasurements(mdf, numAverages=10, frames=1:100,
              fourierTransform=true, loadasreal=true)) == (1634,3,3,10)

  @test size(getMeasurements(mdf,frequencies=1:10, numAverages=10)) == (10,3,50)

end
