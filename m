From: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [BUG] cgroup writeback list corruption
Date: Wed, 16 Mar 2016 19:36:41 -0700
Message-ID: <CAAeU0aP6usVKUZTm7ncrkiEHEY5YGgeM3syhm9BeJvPk6k6wxA@mail.gmail.com>
References: <CAAeU0aMYeM_39Y2+PaRvyB1nqAPYZSNngJ1eBRmrxn7gKAt2Mg@mail.gmail.com>
	<20160316221015.GL21104@mtj.duckdns.org>
	<20160317011350.GN21104@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=mTPZlRpESATK/PzkyXs1nkCd6iND5BmtpKLyiz+LseY=;
        b=IVVhlhixvMMYvxZCrvTuAAv2uNFI755j/gdhgX5zuuFn3CSkF6ybK3mxIU+sqo0Rx/
         WAQapGK3Im0FA3/p8ae652cp1zTveFaCsWWV7Q2oRqzFq8IiHFWx3kOEcZ95o7L1Ydoe
         jjg/ygYYoIVP3lUULdb0Wzkzwn4h6FVOpumSdlPaI6GNSWI8SW0y2cx0hjP0vMw9amh7
         a2LuAOvyGy0YIxGmCUUHxBcaqi+iakqezzQ1uTgCiXFvAcJ8SXd6hpQaWIWVHVoRzLje
         eFkCemYbnRAMgnftegiv5bvwFTh+4X6AYxwjZQovlN6Vo4FHA7deznvycYZqr7IUXf7+
         n5CA==
In-Reply-To: <20160317011350.GN21104-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Wed, Mar 16, 2016 at 6:13 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Tahsin.
>
> FYI, this is the preliminary patch I'm trying to test.  I'm running
> the repro case w/o the patch but the bug hasn't triggered yet.

Please let me know if you want me to send the repro config. I don't have
it available at the moment but I can reconstruct it if you want.

thanks
