From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm: oom: introduce cpuset oom
Date: Thu, 17 Aug 2023 12:45:43 -0400
Message-ID: <0aa69b7b-8955-f495-0026-8c83597a4739@redhat.com>
References: <20230411065816.9798-1-ligang.bdlg@bytedance.com>
 <ZDVwaqzOBNTpuR1w@dhcp22.suse.cz>
 <9ba0de31-b9b8-fb10-011e-b24e9dba5ccd@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692290748;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EMYB6Aa88h1ABn1kG37sttadyKX0sLxsWeo4W40AHWI=;
        b=jAdGgx0LRWhvNObkUL98YU4pzCMemWpjhXVMCl3dGob4mTnb6QGg20QSMoQP5PGW5DWx+r
        6NLyPB6xy44dPIHqq7TpBy0fYedZtdaLDHNUr1yFTjIEebhJeThJdD2gPRlFa1/IDKBKjH
        5VFjW8PR2JVYCJudcgIJGYLQSlXx2CA=
Content-Language: en-US
In-Reply-To: <9ba0de31-b9b8-fb10-011e-b24e9dba5ccd-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Gang Li <gang.li-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 8/17/23 04:40, Gang Li wrote:
>
> Since __GFP_HARDWALL is set as long as cpuset is enabled, I think we can
> use it to determine if we are under the constraint of CPUSET.
>
> But I have a question: Why we always set __GFP_HARDWALL when cpuset is
> enabled, regardless of the value of cpuset.mem_hardwall?

There is no direct dependency between cpuset.mem_hardwall and the 
__GFP_HARDWALL flag. When cpuset is enabled, all user memory allocation 
should be subjected to the cpuset memory constraint. In the case of 
non-user memory allocation, it can fall back to to the node mask of an 
ancestor up to the root cgroup, i.e. all memory nodes. 
cpuset.mem_hardwall enables a barrier to this upward search.

Note that cpuset.mem_hardwall is a v1 feature that is not available in 
cgroup v2.

Cheers,
Longman

