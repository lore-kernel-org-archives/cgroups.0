From: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Using cgroup membership for resource access control?
Date: Mon, 6 Feb 2023 13:21:05 -0800
Message-ID: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675718467; x=1707254467;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=oOMOY8LLrCs8UUvKbPbScwtm0njsbY4fgCgiPc84ANI=;
  b=HELr36d6uUcZCelGuKA5vchPbFg105UFUWAlKlEhbB0s6YbE+afB6L3q
   p6zNVzOWnI8w/PtkzgBG91vQQBakUy2LqAmL62hoHUYu+9eKc7TV0aRf1
   bzvUTYnEraztcCDFEab6OD/vqhGy3PQIcZF7JR1g7BHFmrnP2ci3Vy1YM
   Ang0AS4uOy26xmn3ypPAfmsf8v11tLoBMHc/lx4hpBb/tP+Wh5a8vt5cM
   hZ88RzbbPts7jSF+gVaeBNKkrez+KqQ/TupRFHo7g5EGHlIfpGC13Dkuk
   EdmbPcOPlBxAjIgi77ILguYu0jh/9xC0G60XJ0shvygLHPNhRTfGWdDiv
   g==;
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ramesh Thomas <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi,

Cgroups primary function seems to be to divide limited resources and
make sure that they are allocated "fairly" (where the sysadmin decides
what is fair, and how much of each resource should be made available to
groups of processes).

Intel has a h/w feature in the DSA (Data Streaming Accelerator) device
that will allow a process to offer access to bounded virtual windows
into its address space to other processes.

The case where one process wants to make this offer to just one other
process seems simple.

But the h/w allows, and a process might want, to offer a virtual window
to several other processes. As soon as anyone says the words "several
processes" the immediate thought is "can cgroups help with this?"

I'm thinking along these lines:

1) Sysadmin creates a cgroup for a "job". Initializes the limits on
how many of these virtual windows can be used (h/w has a fixed number).
Assigns tasks in the job to this cgroup.

2) Tasks in the job that want to offer virtual windows call into the
driver to allocate and partially set up windows tagged with "available
to any other process in my cgroup".

3) Other tasks in the group ask the driver to complete the h/w
initialization by adding them (their PASID) to the access list
for each window.

My questions:

1) Is this horrible - have I misunderstood cgroups?
	1a) If this is horrible, can it be rescued?

2) Will it work - is "membership in a cgroup" a valid security mechanism?

3) Has someone done something similar before (so I can learn from their code)?

4) Is there an existing exported API to help. I see task_cgroup_path()
which looks generally helpful (though I'd prefer a task_cgroup() that
just takes a task and gives me the cgroup to which it belongs.)

Thanks

-Tony
