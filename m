From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v10 0/8] cgroup/cpuset: Major cpu partition code
 restructuring
Date: Wed, 4 May 2022 13:28:01 +0200
Message-ID: <20220504112801.GB15266@blackbody.suse.cz>
References: <20220503162149.1764245-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1651663683; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=L/cwtplOe2rgvl+3N8cSAUIrSPV4AbYQm0HK7GYEw/o=;
        b=b/3AJN5rM/RWE3pUTW2qAKjzrKoqzbCyWmvFi0Rg3L+vFlZBs4SB15fcinTkpJxq51ABoL
        T9gJXqsYz3iYWAwspcqrY8mtACL8gk8r/68VZWbNwdsSyp1MtWr8x3rPmrT9OlY5whJg+C
        k6HnrcWYn88n7XSQX5Yy0jvoH+nzgss=
Content-Disposition: inline
In-Reply-To: <20220503162149.1764245-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello.

On Tue, May 03, 2022 at 12:21:41PM -0400, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> v10:
>  - Relax constraints for changes made to "cpuset.cpus"
>    and "cpuset.cpus.partition" as suggested. Now almost all changes
>    are allowed.

I see there were also some other changes from v9 (like the first patches
of series).
Any chance you have a public git repo with both versions for a
convenient range-diff?

Thanks,
Michal
