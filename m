From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 05/16] consider a memcg parameter in kmem_create_cache
Date: Mon, 24 Sep 2012 18:38:48 +0300
Message-ID: <CAOJsxLGFWQFNUUN3sDeB2sn0S-QM-6Ut_d02HjmF6mB5aMytoA@mail.gmail.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com>
	<1347977530-29755-6-git-send-email-glommer@parallels.com>
	<20120921181458.GG7264@google.com>
	<506015E7.8030900@parallels.com>
	<00000139f84bdedc-aae672a6-2908-4cb8-8ed3-8fedf67a21af-000000@email.amazonses.com>
	<50605500.5050606@parallels.com>
	<00000139f8836571-6ddc9d5b-1d5f-4542-92f9-ad11070e5b7d-000000@email.amazonses.com>
	<506063B8.70305@parallels.com>
	<00000139f890a302-980aee84-40b2-433f-8dbd-e7b1d219f00d-000000@email.amazonses.com>
	<506066E3.6050705@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=0YeOBntE0CsK+oi1iypXJLe2D9xh39oUl1kk7hfpGEg=;
        b=rGXmn6PCPUkyDr9xzksZa/EdRD51DCixKToQyBDmP+yTtGmsT3N6My+uXVaw1McvPZ
         9RDFjLhyHRvACIy7CE0OqtYQvAVdItWzSwJ4t8fVpgQ4L+JdIoHdpkQiQZ4D/1xuadgx
         eVQHwJGA6nZsJNFBTOGMTEwG37SXgJ9cvVPMHxqgwSniOZqAQVgvQQoou5MAGe1isjsK
         XsiNPf2fAB44DYQZ8GfIRX3tV9AKBf4pSBkTNPHeFw9pe8P8hYV1DGeFC25Q1shqgxG6
         CPHxLJafh/UlGpO4n8pCHPmcvjAdV/GQzXcDC6BInHaAcuDjlZJAdK1eij/yalmQBNsk
         SOmg==
In-Reply-To: <506066E3.6050705-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "<linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>" <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, "<devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>" <devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, "<linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On 09/24/2012 05:56 PM, Christoph Lameter wrote:
>> On Mon, 24 Sep 2012, Glauber Costa wrote:
>>
>>> The reason I say it is orthogonal, is that people will still want to see
>>> their caches in /proc/slabinfo, regardless of wherever else they'll be.
>>> It was a requirement from Pekka in one of the first times I posted this,
>>> IIRC.
>>
>> They want to see total counts there true. But as I said we already have a
>> duplication of the statistics otherwise. We have never done the scheme
>> that you propose. That is unexpected. I would not expect the numbers to be
>> there.

On Mon, Sep 24, 2012 at 4:57 PM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> I myself personally believe it can potentially clutter slabinfo, and
> won't put my energy in defending the current implementation. What I
> don't want is to keep switching between implementations.
>
> Pekka, Tejun, what do you guys say here?

So Christoph is proposing that the new caches appear somewhere under
the cgroups directory and /proc/slabinfo includes aggregated counts,
right? I'm certainly OK with that.
