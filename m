From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [RESEND, PATCH 6/6] memcg: cleanup memcg_check_events()
Date: Mon, 16 Jan 2012 13:59:57 +0200
Message-ID: <20120116115957.GB25687@shutemov.name>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-6-git-send-email-kirill@shutemov.name>
 <20120109134108.GF3588@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120109134108.GF3588-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

On Mon, Jan 09, 2012 at 02:41:08PM +0100, Johannes Weiner wrote:
> On Fri, Jan 06, 2012 at 10:57:52PM +0200, Kirill A. Shutemov wrote:
> > From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> > 
> > Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>

...

> I'm about to remove the soft limit part of this code, so we'll be able
> to condense this back into a single #if block again, anyway.
> 
> I would much prefer having the extra #if in the code over this patch
> just to silence the warning for now.

The patch is informative only. I agree with Michal Hocko. It introduce too
much noise to fix one warning. Just ignore it.

-- 
 Kirill A. Shutemov
