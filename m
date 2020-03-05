From: "Daniel Xu" <dxu-zUS5+7O8QwqlVyrhU4qvOw@public.gmane.org>
Subject: Re: Memory reclaim protection and cgroup nesting (desktop use)
Date: Wed, 04 Mar 2020 17:29:18 -0800
Message-ID: <5e0c59bd-ad59-4999-9a41-4239b96b1fc9@www.fastmail.com>
References: <d4826b9e568f1ab7df19f94c409df11956a8e262.camel@sipsolutions.net>
 <20200304163044.GF189690@mtj.thefacebook.com>
 <20200304100231.2213a982@lwn.net>
 <20200304171051.GK189690@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=T9JaF4sGM4j6APTDjyVGLfdoZyWnOlU
        PZp/Hqn+ZrA8=; b=y1apH15KPMNh2yNs/t38MuiG9vqULi0LjWZ8Ury1oTimMXN
        hX5b54APNeUiFQdR8N5YAT9tHIxCn7eVzuDYjh1yo586pzuq4Vs6XSlQphYATqlJ
        akFK/WIxGNNIxnGCwCOnVISQxbl/7KRPhFH14XD9tsDb5bXUfJR6TsRTVlq5rgyc
        jd9NYf5Vjmq+S5lq7I3SYqXfE+E86CqnYEUE1QOcvAcJB2CHocXxi0kpzjHllyEV
        x+YHqeFvrCKv3jDYaTjxjxcSqpDUg9nibza8Bt0vpm+PqrzF0nhdojGD9y32SgE8
        GtaeSukZXFag/JTYElWPcTXYwkgGsXT7xq7HgDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=T9JaF4
        sGM4j6APTDjyVGLfdoZyWnOlUPZp/Hqn+ZrA8=; b=ZYnJu/Wq3I5F4OKn/ROuu4
        sZ2gB/Y+V8sfwnXZ0RaE3s/AJhQLc0THe9jvAlNiTOYL4jnCTtAKN9ZW/wTtezWR
        KUGPnSaAOAttEvL0iFN7JAe3JTLygMONl/Wcov0s92NmjAf2BZN+fFy3PAg9HJSR
        zmHVvxkXpwTuKuDFfnfJkbqpxMK4Anb85YYKozLeOplZt0n5/9jh2SDpAJBl1eOI
        eApMgsTWcQTlUOoarKQvsaizLwYqJ5AKFGLxt6AwiRyVRy6W0MSz+j5Ms58UiU41
        75Ax1rxAbx4xz8uj6Be8UOkIA1QPnhUvxP8eeYaHEYOn+NDxlVpauBBtkEfTKH9g
        ==
In-Reply-To: <20200304171051.GK189690-146+VewaZzwNjtGbbfXrCEEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
Cc: Benjamin Berg <benjamin-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Wed, Mar 4, 2020, at 9:10 AM, Tejun Heo wrote:
> On Wed, Mar 04, 2020 at 10:02:31AM -0700, Jonathan Corbet wrote:
> > On Wed, 4 Mar 2020 11:30:44 -0500
> > Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > 
> > > > (In a realistic scenario I expect to have swap and then reserving maybe
> > > > a few hundred MiB; DAMON might help with finding good values.)  
> > > 
> > > What's DAMON?
> > 
> > 	https://lwn.net/Articles/812707/
> 
> Ah, thanks a lot for the link. That's neat. For determining workload
> size, we're using senpai:
> 
>  https://github.com/facebookincubator/senpai
[...]

For reference, senpai is currently deployed as an oomd plugin:
https://github.com/facebookincubator/oomd/blob/master/src/oomd/plugins/Senpai.cpp .

The python version might be a bit out of date -- Johannes probably knows.
