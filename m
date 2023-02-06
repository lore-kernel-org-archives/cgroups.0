From: "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Using cgroup membership for resource access control?
Date: Mon, 6 Feb 2023 22:18:11 +0000
Message-ID: <SJ1PR11MB6083C61BCA70A31F8C0F12ECFCDA9@SJ1PR11MB6083.namprd11.prod.outlook.com>
References: <Y+FvQbfTdcTe9GVu@agluck-desk3.sc.intel.com>
 <Y+F0NA9iI0zlONz7@slm.duckdns.org> <Y+F0mXS9z0flDhf7@slm.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675721895; x=1707257895;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vBkQGh6/0VEmRsJ8IheNAahzdjWtx0a6BuO2ZvFhNzo=;
  b=cvNhiU6Trd0heMrLpmnbJ5sVbazUoq4ECCQDhEbmbzmktgrVeg/5u8xD
   9HqHHZQ1QGq+GDxGjUE/ru4YVdnQSuRZOyuYhvyWgXx/vCZiGe8lqqXUX
   RqjG1BfHXMs6WeYAIeg37+fZUPvHx3QFBIB66SeeWP+0jKxg/dAQf+mbV
   AZLejG9lWKGPAcVPVXFUTC3VrrAtOiHCM0FrlgFaZHEpcXT5Je3MhmSzP
   JoN9DrnlLGrBfwsZfvk11Pr1DRIfkPlYTcdTpp60yr97OdS8lq/7q3PNW
   hj7Bzhcrj2DmLyyGegxNawPdW1YmGYcQfJgcABoIZLrQgatWjGTkii2lq
   A==;
In-Reply-To: <Y+F0mXS9z0flDhf7-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Thomas, Ramesh" <ramesh.thomas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Tejun,

Thanks for the quick response.

> In case it wasn't clear - use the misc controller to restrict which cgrou=
ps
> can get how many but as for sharing domain, use more traditional mechanis=
ms
> whether that's sharing through cloning, fd passing, shared path with perm
> checks or whatever.

That's always an option. But feels like a lot of complexity during setup th=
at
I'd like to explore ways to avoid.

Some extra details of a workload that will use these shared virtual windows=
.

Imagine some AI training application with one process running per core on
a server with a hundred or so cores. Each of these processes wants periodic=
ally
to share work so far on a subset of the problem with one or more other proc=
esses.
The "virtual windows" allow an accelerator device to copy data between a re=
gion
in the source process (the owner of the virtual window) and another process=
 that
needs to access/supply updates.

Process tree is easy if the test is just "do these two tasks have the same =
getppid()?"
Seems harder if the process tree is more complex and I want "Are these two =
processes
both descended from a particular common ancestor?"

Using fd passing would involve an O(N^2) step where each process talks to e=
ach
other process in turn to complete a link in the mesh of connections. This w=
ould need
to be repeated if additional processes are started.

It would be much nicer to have an operation that matches what the applicati=
ons
want to do, namely "I want to broadcast-share this with all my peers".

[N.B. I've suggested that these folks should just re-write their applicatio=
ns to
simply attach to a giant blob of shared memory, and thus avoid all of this.=
 But
that doesn't fit for various reasons]

-Tony
