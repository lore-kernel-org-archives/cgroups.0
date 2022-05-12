From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcontrol: Export memcg->watermark via sysfs for
 v2 memcg
Date: Thu, 12 May 2022 11:11:13 +0200
Message-ID: <20220512091113.GB5536@blackbody.suse.cz>
References: <20220507050916.GA13577@us192.sjc.aristanetworks.com>
 <20220511174953.GC31592@blackbody.suse.cz>
 <CAPD3tpG_mDq+zpKnFTKgWCuW9_wCfsHMu2ndzOEBsLaqZp-KWA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652346675; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fZGQ/vOR7gCkfyiu8i5HUwuHnaGqSWUWPuuLMrnW1vc=;
        b=LDxw38MEZfmzD+EtDUv1t93Y8YoJWLOHk+Eu4JFrfa9EGfepnpJ9EJHfZ0A65xQkqiJaN2
        26TaOHuYxBoiGZPGYK7fdj4HeNMiFiSeP1xJ5yQx4DebxKyQ67/5EhHpigDizkgnhx2NWi
        Oo7tRoCFfRpQG+GClWS1D5LXPsbUI30=
Content-Disposition: inline
In-Reply-To: <CAPD3tpG_mDq+zpKnFTKgWCuW9_wCfsHMu2ndzOEBsLaqZp-KWA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Thu, May 12, 2022 at 08:18:01AM +0530, Ganesan Rajagopal <rganesan-nzgTgzXrdUbQT0dZR+AlfA@public.gmane.org> wrote:
> Good point. The patch has already been picked up for mm-unstable.

Oh, I didn't notice that.

> I don't know what's the process in this situation. Should I post a
> "[PATCH v3]" with an updated commit message?

Or you can send a fixup for folding? (I see this is something new,
you better ask Andrew.)

Michal
