From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Query regarding deadlock involving cgroup_threadgroup_rwsem and
 cpu_hotplug_lock
Date: Wed, 20 Jul 2022 08:05:03 -1000
Message-ID: <YthDz4BnfYHce1od@slm.duckdns.org>
References: <8245b710-8acb-d8e6-7045-99a5f71dad4e@oracle.com>
 <26d0e4cc-be0e-2c12-6174-dfbb1edb1ed6@oracle.com>
 <bbc01477-231b-3dbb-3e09-9338f5413f06@oracle.com>
 <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YWTDneNY8P5vWW2QTCkwFAjSMu7YWo8lKAMC6oCSaaQ=;
        b=oOtz9PsBinTflz88HKUTWrJh15Cle1xn8l7q18DcwWR4RAQQoC1u4AiUoWdbGWqesa
         62bNh9C6BftUhOKODBoCr/KkXyz9BeZkLIw7iOlBiHkRUzEkts542clfCFazWIHo4cq0
         eDo8cdN3gyi3x8DSn8uwPy8crW/bairzY9qvpP1bGcHdIRL3aZDrk1yg6qvDA0Fj3JXp
         d+kdlb5JmQ5RnOGq+xgkxrpa3j8vmneroyZgjaE1LRiW+aaunRjbo4eu6y4pcpz/qLkD
         KzylACtgOLbHjyysmtuUB5LfKCwwCQRhvLzvpaL/68Yzm7dnzisw3BClyDoYi0lcYzLa
         MPag==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <224b19f3-912d-b858-7af4-185b8e55bc66-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 20, 2022 at 05:31:51PM +0530, Mukesh Ojha wrote:
> Looks like these patches are the fixes.
> 
> https://lore.kernel.org/all/YtDvN0wJ6CKaEPN8-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/#r
> 
> Would let Tejun confirm this .

Yeah, looks like the same issue. I'll write up a patch later this week /
early next unless someone beats me to it.

Thanks.

-- 
tejun
