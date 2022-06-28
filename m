From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH cgroup] cgroup: set the correct return code if hierarchy
 limits are reached
Date: Tue, 28 Jun 2022 18:22:33 +0900
Message-ID: <YrrIWe/nn5hoVyu9@mtj.duckdns.org>
References: <186d5b5b-a082-3814-9963-bf57dfe08511@openvz.org>
 <d8a9e9c6-856e-1502-95ac-abf9700ff568@openvz.org>
 <YrpO9CUDt8hpUprr@castle>
 <17916824-ba97-68ba-8166-9402d5f4440c@openvz.org>
 <20220628091648.GA12249@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=/RPscv3+8g8rx4jXo23oMEeXPiuNo7BXGYwm+0AjXxs=;
        b=To1tuJ6ezfSPRvfvYleOSb9lKKOhueWfZvhziXTEgCM9PUQE9mQ/xhT/GQKDwAx3+K
         VCwO+26BUmVeT7tjCm709OpoNluVA5TQnQMiEBOnZWK6u0h7/2MQKkzXLs/QTBPtLd+t
         uaEv/5/AD3aMBX+7rY78FIuqtsaMYfGOxtLmBiFL7mE3st9gwwEYdkaho0GnDCcCS+C6
         4iEp8WxQDcPWTMDrt/QPMRtV+Nsnq3jb5UHhTTcpJedWllF567kplSbpUcwnVLjnZnAa
         /5C8nTucMrmiuELtf9puqfjdHfigFReLoMkmJ6zo4PcDCEvdsypTDDGCHRq1camco5J+
         ++lg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220628091648.GA12249@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Vasily Averin <vvs@openvz.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Michal Hocko <mhocko@suse.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, kernel@openvz.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Muchun Song <songmuchun@bytedance.com>, cgroups@vger.kernel.org

On Tue, Jun 28, 2022 at 11:16:48AM +0200, Michal Koutn=FD wrote:
> The mkdir(2) manpage doesn't list EAGAIN at all. ENOSPC makes better
> sense here. (And I suspect the dependency on this particular value won't
> be very wide spread.)

Given how we use these system calls as triggers for random kernel
operations, I don't think adhering to posix standard is necessary or
possible. Using an error code which isn't listed in the man page isn't
particularly high in the list of discrepancies.

Again, I'm not against changing it but I'd like to see better
rationales. On one side, we have "it's been this way for a long time
and there's nothing particularly broken about it". I'm not sure the
arguments we have for the other side is strong enough yet.

Thanks.

--=20
tejun
