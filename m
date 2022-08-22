From: Chris Frey <cdfrey-4/nNOD19pEMY+eTVAdjFZg@public.gmane.org>
Subject: an argument for keeping oom_control in cgroups v2
Date: Mon, 22 Aug 2022 08:04:02 -0400
Message-ID: <20220822120402.GA20333@foursquare.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In cgroups v1 we had:

	memory.soft_limit_in_bytes
	memory.limit_in_bytes
	memory.memsw.limit_in_bytes
	memory.oom_control

Using these features, we could achieve:

	- cause programs that were memory hungry to suffer performance, but
	  not stop (soft limit)

	- cause programs to swap before the system actually ran out of memory
	  (limit)

	- cause programs to be OOM-killed if they used too much swap
	  (memsw.limit...)

	- cause programs to halt instead of get killed (oom_control)

That last feature is something I haven't seen duplicated in the settings
for cgroups v2.  In terms of handling a truly non-malicious memory hungry
program, it is a feature that has no equal, because the user may require
time to free up memory elsewhere before allocating more to the program,
and he may not want the performance degredation, nor the loss of work,
that comes from the other options.

Is there a reason why it wasn't included in v2?  Is there hope that it will
come back?

Thanks,
- Chris

