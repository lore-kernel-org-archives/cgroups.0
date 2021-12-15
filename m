From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 6/7] cgroup/cpuset: Update description of
 cpuset.cpus.partition in cgroup-v2.rst
Date: Wed, 15 Dec 2021 08:35:58 -1000
Message-ID: <Ybo1jmNvM6sblcJq@slm.duckdns.org>
References: <20211205183220.818872-1-longman@redhat.com>
 <20211205183220.818872-7-longman@redhat.com>
 <Ybe0YWEo7Wp7wib9@slm.duckdns.org>
 <20211215144450.GC25459@blackbody.suse.cz>
 <96018978-6b7f-1e7f-1012-9df7f7996ec5@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sphiaH5KnmKIhXvaCjxOtnGbcU9KdLom7iLRZ9t9/OM=;
        b=OXZjFnMocX9uFmrlxixUhWGpHHaV1MbVgChhnY+iiHKbnMpZ0x8KzP0FsxC/s3DdzE
         87++rrRG6KT0U4LWdkSCOtxJM2j7wSBBmHZ0+K0xnPSB5OHqh2JPdigZr/qy9dtPzF4B
         pInBtHxZRy3a1+i8e8PAXoKVzDnPlgpSk+yt+TNL6jo1J15RfbGN/iCT6JhBEgiNclJO
         lTltrL5JttU8S/fKw10ua4K2exbyUUK9nf7jI95EVoSTx3yrW7RJ2rjgjZCpDLquVgfr
         G3EcqsbIAMBt5nVaGPyof3u5uwik8+RkIw5Rlk8q/CaO1/9ZmU9k7aJHOWcpyhqZwccf
         J9aw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <96018978-6b7f-1e7f-1012-9df7f7996ec5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello, Waiman.

On Wed, Dec 15, 2021 at 01:16:43PM -0500, Waiman Long wrote:
> Allowing direct transition from member to invalid partition doesn't feel
> right for me. A casual user may assume a partition is correctly formed
> without double checking the "cpuset.partition" value. Returning an error
> will prevent this kind of issue. If returning more information about the
> failure is the main reason for allowing the invalid partition transition, we
> can extend the "cpuset.partition" read syntax to also show the reason for
> the previous failure.

I don't think it's a good idea to display error messages without a way to
link the error to the one who triggered it. This is the same problem we had
with resettable counters. It only works for scenarios where one guy is
sitting in front of the computer but gets nastry for more complex scnearios
and automation.

I understand that allowing transitions to invalid state can feel jarring.
There are pros and cons to both approaches. It's similar dynamics tho.
Erroring out may be more intuitive for a casual user but makes it harder for
more complex scenarios because whether a given operation errors or not is
dependent on external asynchronous states, there's no good way of reporting
the exact nature of the error or detecting when the operation would succeed
in the future, and the error conditions are rather arbitrary.

Thanks.

-- 
tejun
