From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 1/9] cgroup/cpuset: Miscellaneous code cleanup
Date: Mon, 26 Jul 2021 12:56:51 -1000
Message-ID: <YP89s+r6sIJfH1IP@mtj.duckdns.org>
References: <20210720141834.10624-1-longman@redhat.com>
 <20210720141834.10624-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rywULGqqJHW4uW6Lie4psExGDsJbpbasiEeSTM/fJfo=;
        b=aH5KPGTtmHB56BZ+Xc8UtKMKCaLJy9PkkE+AXhNMxOw9gQkxFCCtD2uMyQ0cMIAi01
         ol8ew9gUmas1187lR12GPtdiM9K6AqgALsLefECSsBvi780ZQoyuWvz8yb0zegl4EAwN
         PmmaHFI6vByfskFP7MT5J5RPrG3M8kjy3TYZIibP27v5XNSq2YkYoGy76YRiRkfA/LMT
         tqkJCBcfwAFhDxb6gIy1wYgfgF8BRRNAUQ0h7YkRN45Z2tBBbxphB/KvHpcHb/lArIv3
         D/ViVSGKwIPbY/jGjleEPNfuRs7KONRUXze9JrnMpBORGehXmSGGEQvtX52n1r6WSua5
         RaTA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210720141834.10624-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

On Tue, Jul 20, 2021 at 10:18:26AM -0400, Waiman Long wrote:
> Use more descriptive variable names for update_prstate(), remove
> unnecessary code and fix some typos. There is no functional change.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-5.15.

Thanks.

-- 
tejun
