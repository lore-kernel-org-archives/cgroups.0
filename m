From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v8 0/6] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Wed, 10 Nov 2021 19:15:58 +0100
Message-ID: <20211110181558.GB51149@blackbody.suse.cz>
References: <20211018143619.205065-1-longman@redhat.com>
 <20211110111357.17617-1-felix.moessbauer@siemens.com>
 <20211110135653.GD20566@blackbody.suse.cz>
 <AM9PR10MB4869C14EAE01B87C0037BF6A89939@AM9PR10MB4869.EURPRD10.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636568164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WrfmgeAir/bcyFgACSGpgDgNuM+uhrNAmeRnW3A3QN0=;
        b=CvbVadvRn6in1GwXmbxlxRhD5agTW4BW2HFq6oifyXHR2R6X4K9nvUrApT3LJ7EKkEzPiP
        kEYCK/rJTOgzQxglqUQNTOwOVaUTJIVMQtXTo9PwTFj/u4ME10JU1UxVtcEYdjkbeyy4MU
        X+3kR+EBq/NX4NNVl9w/zfUkh8/cVHQ=
Content-Disposition: inline
In-Reply-To: <AM9PR10MB4869C14EAE01B87C0037BF6A89939-M49tMopaQCDO+/9PLUklKbUAtUbAAahqZmpNikb/MY7jO8Y7rvWZVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org>
Cc: "longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "guro-b10kYP2dOMg@public.gmane.org" <guro-b10kYP2dOMg@public.gmane.org>, "hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org" <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org" <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, "mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, t

On Wed, Nov 10, 2021 at 03:21:54PM +0000, "Moessbauer, Felix" <felix.moessbauer-kv7WeFo6aLtBDgjK7y7TUQ@public.gmane.org> wrote:
> 2. Threads can be started on non-rt CPUs and then bound to a specific rt CPU.
> This binding can be specified before thread creation via pthread_create.
> By that, you can make sure that at no point in time a thread has a
> "forbidden" CPU in its affinities.

It should boil down to some clone$version(2) and sched_setaffinity(2)
calls, so strictly speaking even with pthread_create(3) the thread is
shortly running with the parent's affinity.

> With cgroup2, you cannot guarantee the second aspect, as thread
> creation and moving to a cgroup is not an atomic operation.

As suggested by others, CLONE_INTO_CGROUP (into cpuset cgroup) can
actually "hide" the migration into the clone3() call.

> At creation time, you cannot set the final affinity mask (as you
> create it in the non-rt group and there the CPU is not in the
> cpuset.cpus).
> Once you move the thread to the rt cgroup, it has a default mask and
> by that can be executed on other rt cores.

Good point. Perhaps you could work this around by having another level
of (non-root partition) cpuset cgroups for individual CPUs? (Maybe
there's more clever approach, this is just first to come into my mind.)

Michal
