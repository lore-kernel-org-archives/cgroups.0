From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [RESEND, PATCH 4/6] memcg: fix broken boolean expression
Date: Mon, 9 Jan 2012 15:04:04 +0100
Message-ID: <20120109140404.GG3588@cmpxchg.org>
References: <1325883472-5614-1-git-send-email-kirill@shutemov.name>
 <1325883472-5614-4-git-send-email-kirill@shutemov.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1325883472-5614-4-git-send-email-kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Fri, Jan 06, 2012 at 10:57:50PM +0200, Kirill A. Shutemov wrote:
> From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> 
> action != CPU_DEAD || action != CPU_DEAD_FROZEN is always true.
> 
> Signed-off-by: Kirill A. Shutemov <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I think you don't need to actually CC stable via email.  If you
include that tag, they will pick it up once the patch hits mainline.

The changelog is too terse, doubly so for a patch that should go into
stable.  How is the code supposed to work?  What are the consequences
of the bug?
