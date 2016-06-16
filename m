From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] cgroup: disable irqs while holding css_set_lock
Date: Thu, 16 Jun 2016 18:14:34 -0400
Message-ID: <20160616221434.GI3262@mtj.duckdns.org>
References: <1465325475-30593-1-git-send-email-bristot@redhat.com>
 <20160607193008.GA31708@htj.duckdns.org>
 <6f15f27f-3757-5413-4292-1386e95bc278@redhat.com>
 <38469b61-7cc5-5fec-4de3-0e9a616dfe95@redhat.com>
 <20160616220315.GH3262@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QJWct6XELjECYXPHrQ58CeDBwi/PYMslrwoAirMjBtc=;
        b=OWRToi3XQYb5rJ9I75eMRral/LaGzg58JGSfNCBYXbMavKw1UiZYfucbSy8k3ztq4r
         m7evOi2X0M301V4jvg7lIDA4raldCSL+a21R9e4d5E1xPY884Yv2xYUqKFg3up5Xx+v8
         9LI+MgxBPW40odbYdBgkBnd+DDV0GcA/tnKyBN2zy/3pisZngYeQY37xWgSlEvMoVQqB
         zXScRqeOsEpxjawPDmZLghrWnrSVWUNDPzxZQh9pbBG4XEpezupfO1kos3/sQ/D9NIPe
         iDKs7gUO7tJgmOI2RkJVW7PD90hOQ4z9OiJrsEmhnDtWnG75COb5vk1jNkART92fhUtA
         sy2w==
Content-Disposition: inline
In-Reply-To: <20160616220315.GH3262@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Bristot de Oliveira <daolivei@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>, "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@arm.com>, cgroups@vger.kernel.org

On Thu, Jun 16, 2016 at 06:03:15PM -0400, Tejun Heo wrote:
> On Thu, Jun 16, 2016 at 06:48:56PM -0300, Daniel Bristot de Oliveira wrote:
> > On 06/07/2016 05:05 PM, Daniel Bristot de Oliveira wrote:
> > > On 06/07/2016 04:30 PM, Tejun Heo wrote:
> > >> Is this something in mainline?  This forces all task free path to be
> > >> irq-safe, which *could* be fine but it's weird to make cgroup free
> > >> path irq-safe for something which isn't in mainline.
> > > 
> > > you mean, mainline linux kernel? if so, yes it is. I was running the
> > > v4.7-rc2 from Linus, as is.... no external patches applied.
> > > 
> > 
> > is there any other question/objection about this patch?
> 
> Nope, I was just on vacation.  Applied to cgroup/for-4.7-fixes.

Except that the patch seems to use irqsave/restore instead of plain
irq ones in places.  Care to update those?

Thanks!

-- 
tejun
