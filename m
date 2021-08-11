From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 1/6] cgroup/cpuset: Enable event notification when
 partition state changes
Date: Wed, 11 Aug 2021 08:04:31 -1000
Message-ID: <YRQRL0M5SAKugVQ6@slm.duckdns.org>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OiO20UHglT1NPC5OUbJaD10lEfkdZcWqGJoPTWQxoOU=;
        b=jd8jqbBx9YTWzOvvdMy5jg2ItpkiGKByB0gZfqiqlaARW76DkXmvqaRoGwQ79Jjkvu
         1KguaVTlcK8NDQFqc5bQ+gu3GX9ofT3kUKrMsMVwhJ+ZT2Ml8o/CYmARQXEvkIFiwMhZ
         k/eGDoEkLtJmBVFOdO+M+Wi9m3VG/BTPvWh075Xzsb25oGdsR2YBf3WdEL9FIKZ6l41H
         YSdcXTbTaW3yMF0OiUJTPG/n9zOadpO9ebDwe2HZfSnW8wHZO9E3eoS8wd3UsxmyXKMD
         +f8l7vo5ZilYaWchBBQxT1RfO/NcGKtSbwK5mgcfBidu4JMgafuRJ1Eo86nMU/lylfUu
         dzKA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210811030607.13824-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Tue, Aug 10, 2021 at 11:06:02PM -0400, Waiman Long wrote:
> A valid cpuset partition can become invalid if all its CPUs are offlined
> or somehow removed. This can happen through external events without
> "cpuset.cpus.partition" being touched at all.
> 
> Users that rely on the property of a partition being present do not
> currently have a simple way to get such an event notified other than
> constant periodic polling which is both inefficient and cumbersome.
> 
> To make life easier for those users, event notification is now enabled
> for "cpuset.cpus.partition" whenever its state changes.
> 
> Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
