From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: avoid charge statistics churn during
 page migration
Date: Tue, 5 Aug 2014 09:12:23 -0400
Message-ID: <20140805131223.GA14734@cmpxchg.org>
References: <1407184469-20741-1-git-send-email-hannes@cmpxchg.org>
 <20140805122434.GD15908@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=iTxsz6LojNRtOunV0TDe0pPH5B+SjXvWqXuI5el8LGQ=;
	b=m+mEyi/R7JBU/1YVrG1Axw41e/b4LVRniGhqE+bkQtZ1EkdikxJNsNCrj6/b6YxKhQfDlpcN/jw9rd+HUS/iHSpOHmBa4WKnYehlu7VR4kTH1Q4GYreagHRA+x1WTd5KLdmHLSu59enBykXQxHhlOKyyyZmF3YCUkueNhfJTImA=;
Content-Disposition: inline
In-Reply-To: <20140805122434.GD15908-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Aug 05, 2014 at 02:24:34PM +0200, Michal Hocko wrote:
> On Mon 04-08-14 16:34:29, Johannes Weiner wrote:
> > Charge migration currently disables IRQs twice to update the charge
> > statistics for the old page and then again for the new page.
> > 
> > But migration is a seemless transition of a charge from one physical
> > page to another one of the same size, so this should be a non-event
> > from an accounting point of view.  Leave the statistics alone.
> 
> Moving stats to mem_cgroup_commit_charge sounds logical to me but does
> this work properly even for the fuse replace page cache case when old
> and new pages can already live in different memcgs?

We don't migrate if the new page is already charged.
