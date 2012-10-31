From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/8] cgroup: kill
	cgroup_subsys->__DEPRECATED_clear_css_refs
Date: Wed, 31 Oct 2012 13:11:02 -0700
Message-ID: <CAOS58YPbYoMJ1+3uRfK_ZERyZoaby=FPW7uTpp8dVOSgYC8Mrw@mail.gmail.com>
References: <1351712650-23709-1-git-send-email-tj@kernel.org>
	<1351712650-23709-2-git-send-email-tj@kernel.org>
	<20121031200859.GE1271@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=mime-version:sender:in-reply-to:references:date
	:x-google-sender-auth:message-id:subject:from:to:cc:content-type;
	bh=BGjRFjW1nPDSbS/ICkf5ptUofcSbk25U5MvUvcTR3xo=;
	b=RkNrJb8CVwz3J0+6LwyTksyOCehImUhIxeBqCrnuiASatSHtwqoFoHqFVBQB5/OgLc
	w+7dr8xPVwKbBXl1k+1iEoJq47SxCHrbEDJjmetXq9+TNEO5lAnir7HezrQookhlhiGR
	L6aSNY13giAsJFMU3BB2yBQiW8looIwtosAI2DLeQ595Rr/+5Sm76/2QHRclI5Aj9eMN
	ZZ8VQc3fuRQrjye1CSeLCoYqKys9KQMq5SYlSKIBj9ZUTBjcg00SWp3K7U9cYvaqD/EE
	fq3UKOUKqO60siYevbCXPeb5ipJfwHwsIYQppHdYFKdWwSQOy/ar/4lt7WjHMuXdxv/w
	qnKQ==
In-Reply-To: <20121031200859.GE1271-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

Hello,

On Wed, Oct 31, 2012 at 1:08 PM, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> wrote:
> local_irq_disable doesn't guarantee atomicity, because other CPUs will

Maybe it should say atomicity on the local CPU.

> see the change in steps so this is a bit misleading. The real reason
> AFAICS is that we do not want to hang in css_tryget from IRQ context
> (does this really happen btw.?) which would interrupt cgroup_rmdir
> between we add CSS_DEACT_BIAS and the group is marked CGRP_REMOVED.
> Or am I still missing the point?

Yeah, that's the correct one. We don't want tryget happening between
DEACT_BIAS and REMOVED as it can hang forever there.

Thanks.

-- 
tejun
