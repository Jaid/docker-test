const scriptLocationsExpected = [
  ["buildDocker", "getInputs"],
  ["bump", "extractSemvers"],
  ["bump", "prepareDispatch"],
  ["debug", "actionGithubContext"],
  ["executePushDocker", "getInputs"],
  ["makeDockerTagMatrix", "makeMatrix"],
  ["testDocker", "getInputs"],
  ["testDocker", "runImage"],
  ["uploadDocker", "getDockerHubRef"],
  ["uploadDocker", "getDockerHubTokenLength"],
  ["uploadDocker", "getGithubPackagesRef"],
  ["uploadDocker", "getInputs"],
  ["uploadDocker", "getRefs"],
  ["uploadDocker", "getTags"],
  ["uploadDocker", "prepareVersionTag"],
 ]
 const workflowLocationsExpected = [
   "buildDocker",
   "bump",
   "debug",
   "executePushDocker",
   "makeDockerTagMatrix",
   "pushDocker",
   "testDocker",
   "uploadDocker",
 ]
 import {globby} from "globby"
 import fs from "fs-extra"
 const workflowLocationHits = await globby("*-overlay.yml", {
   cwd: ".github/workflows",
   onlyFiles: true,
 })
 const workflowLocations = workflowLocationHits.map(hit => {
   const removableSymbols = "-overlay.yml".length
   return hit.slice(0, -removableSymbols)
 })
 const scriptLocationHits = await globby("*-overlay/*.ts", {
   cwd: ".github/workflows",
   onlyFiles: true,
 })
 const scriptLocations = scriptLocationHits.map(hit => {
   const [workflowName, scriptName] = hit.slice(0, -3).split("-overlay/")
 })