From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 15:28:14 +0000
Message-ID: <20191217152814.GB136178@chrisdown.name>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
 <20191217144652.GA7272@dhcp22.suse.cz>
 <20191217150921.GA136178@chrisdown.name>
 <20191217151931.GD7272@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yZaScq9Meta77Nqt7I5hQ1kZiSA6MbL950o5EmEfNTs=;
        b=gJUT5JEsQl19+ZNt2Qx+/ZHcNIpwMpLwtmc3WAvlw5J9AGWaaFAnfS5qHUWnFdoq/Z
         Iu//JE+EtIRQpbdrMqEyYt1JCBMeCaj/mM58p+f9ACzA8KWvvykDijI2qRDt1Hyj90vf
         xXrj8zrMTMHBvMieWexBUEwa23r7dw16hd29k=
Content-Disposition: inline
In-Reply-To: <20191217151931.GD7272@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Michal Hocko writes:
>On Tue 17-12-19 15:09:21, Chris Down wrote:
>[...]
>> (Side note: I'm moderately baffled that a tightly scoped __maybe_unused is
>> considered sinister but somehow disabling -Wunused-function is on the table
>> :-))
>
>Well, I usually do not like to see __maybe_unused because that is prone
>to bit-rot and loses its usefulness. Looking into the recent git logs
>most -Wunused-function led to the code removal (which is really good
>but the compiler is likely to do that already so the overall impact is
>not that large) or more ifdefery. I do not really see many instance of
>__maybe_unused.

Hmm, but __maybe_unused is easy to find and document the reasons behind nearby, 
and then reevaluate at some later time. On the other hand, it's much *harder* 
to reevaluate which functions actually are unused in the long term if we remove 
-Wunused-function, because enabling it to find candidates will result in an 
incredibly amount of noise from those who have missed unused functions 
previously due to the lack of the warning.

Maybe Qian is right and we should just ignore such patches, but I think that 
comes with its own risks that we will alienate perfectly well intentioned new 
contributors to mm without them having any idea why we did that.
