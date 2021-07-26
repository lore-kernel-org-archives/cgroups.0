From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/9] cgroup/cpuset: Add new cpuset partition type &
 empty effecitve cpus
Date: Mon, 26 Jul 2021 13:17:24 -1000
Message-ID: <YP9ChFvrGrDMGzbe@slm.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=lYRTOLatMvzufkXYQLuONyMUV7E9MEoEnSQSV7vItG4=;
        b=ukt/FXGXZhngCDB8sCyEf8mY2XOXpjHXXQIWNQOJlP53/6jrTbcUh985qo1v5ojigo
         3X014eLreM03cB0ysU3KMUG+Mujsn1Y5DgdC7zaLa6Mj+96YbVkESdw0dznKrXX8aAAB
         JzxRFhIYGNXGW6Elo8T/XVcPTKI3RNb06IWRonV6/phiMiu426AlLqdMwIzErsjRxgBT
         9PDSoWdAI7XhvD9sjaSWVcSOOYyzSXgo15dZL+J9vA9qYQHRantJ/QVMil6id/u/lYsj
         2OvKahQUOiSKhFobibcUh7jJDSQjT0M3N/b+QpSGjOb7LYEAKBT3j04vt8UMOwXl5flu
         qX2A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

Hello,

On Tue, Jul 20, 2021 at 10:18:25AM -0400, Waiman Long wrote:
> v3:
>  - Add two new patches (patches 2 & 3) to fix bugs found during the
>    testing process.
>  - Add a new patch to enable inotify event notification when partition
>    become invalid.
>  - Add a test to test event notification when partition become invalid.

I applied parts of the series. I think there was a bit of miscommunication.
I meant that we should use the invalid state as the only way to indicate
errors as long as the error state is something which can be reached through
hot unplug or other uncontrollable changes, and require users to monitor the
state transitions for confirmation and error handling.

Thanks.

-- 
tejun
