# Download test files

fnMeasV1 = "measurement_V1.mdf"
fnMeasV2 = "measurement_V2.mdf"
fnSMV1 = "systemMatrix_V1.mdf"
fnSMV2 = "systemMatrix_V2.mdf"

if !isfile(fnSMV1)
  streamSM = get("http://media.tuhh.de/ibi/mdf/systemMatrix.h5")
  save(streamSM, fnSMV1)
end
if !isfile(fnMeasV1)
  streamMeas = get("http://media.tuhh.de/ibi/mdf/measurement_5.h5")
  save(streamMeas, fnMeasV1)
end

saveasMDF(fnMeasV2, fnMeasV1)
saveasMDF(fnSMV2, fnSMV1)

#loadFullDataset(MPIFile(fnMeasV2))

# Measurement File V1

mdfv1 = MPIFile(fnMeasV1)
@test typeof(mdfv1) == MDFFileV1

mdfv2 = MPIFile(fnMeasV2)
@test typeof(mdfv2) == MDFFileV2

# only test this for v1
@test uuid(mdfv1) == "4b0ffb8429f5f38849f292a206bba885"
@test version(mdfv1) == v"1.0.0"
@test time(mdfv1) == DateTime("2016-02-08T14:28:34.673")

for mdf in (mdfv1,mdfv2)
  @test studyName(mdf) == "Wuerfelphantom"
  @test studyExperiment(mdf) == 18
  @test studyDescription(mdf) == "n.a."
  @test studySubject(mdf) == "Wuerfelphantom"
  @test studyIsSimulation(mdf) == false
  @test studyIsCalibration(mdf) == false

  @test scannerFacility(mdf) == "University Medical Center Hamburg-Eppendorf, Germany"
  @test scannerOperator(mdf) == "n.a."
  @test scannerManufacturer(mdf) == "Bruker/Philips"
  @test scannerModel(mdf) == "n.a."
  @test scannerTopology(mdf) == "FFP"

  @test tracerName(mdf) == "Resovist"
  @test tracerBatch(mdf) == "0"
  @test tracerVendor(mdf) == "n.a."
  @test tracerVolume(mdf) == 0.0
  @test tracerConcentration(mdf) == 0.5
  @test tracerInjectionTime(mdf) == DateTime("2015-09-15T11:17:23.011")

  @test acqStartTime(mdf) == DateTime("2015-09-15T11:17:23.011")
  @test acqGradient(mdf) == [-1.25 -1.25 2.5]
  @test acqFramePeriod(mdf) == 6.528E-4
  @test acqNumFrames(mdf) == 500
  @test acqNumPatches(mdf) == 1
  @test acqFov(mdf) == [0.0224 0.0224 0.0]
  @test acqFovCenter(mdf) == [0.0 0.0 -0.0]

  @test dfNumChannels(mdf) == 3
  @test dfWaveform(mdf) == "sine"
  @test dfStrength(mdf)[:,:,1] == [0.014 0.014 0.0]
  @test dfPhase(mdf)[:,:,1] == [1.5707963267948966 1.5707963267948966 1.5707963267948966]
  @test dfBaseFrequency(mdf) == 2500000.0
  @test dfDivider(mdf)[:,1] == [102; 96; 99]
  @test dfPeriod(mdf) == 6.528E-4

  @test rxNumChannels(mdf) == 3
  @test rxBandwidth(mdf)[1] == 1250000.0
  @test rxNumSamplingPoints(mdf)[1] == 1632
  @test rxNumAverages(mdf) == 1

  @test size( measData(mdf) ) == (1632,3,1,500)
end

# Calibration File V1

smv1 = MPIFile(fnSMV1)
@test typeof(smv1) == MDFFileV1

smv2 = MPIFile(fnSMV2)
@test typeof(smv2) == MDFFileV2

for sm in (smv1,smv2)
  @test size( calibSystemMatrixData(sm) ) == (1936,817,3,1)
  @test size( calibSNR(sm) ) == (817,3)
  @test calibFov(sm) == [0.044; 0.044; 0.001]
  @test calibFovCenter(sm) == [0.0; -0.0; 0.0]
  @test calibSize(sm) == [44; 44; 1]
  @test calibOrder(sm) == "xyz"
  @test calibPositions(smv1) == nothing
  @test calibOffsetField(smv1) == nothing
  @test calibDeltaSampleSize(sm) == [0.001; 0.001; 0.001]
  @test calibMethod(sm) == "robot"
end
