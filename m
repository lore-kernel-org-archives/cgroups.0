From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 13 May 2021 10:47:28 -0300
Message-ID: <20210513134728.GE1002214@nvidia.com>
References: <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com> <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com> <YJDFj+sAv41JRIo4@yekko>
 <20210504181537.GC1370958@nvidia.com> <YJzAsBNF1irJxRGg@yekko>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yn6P6jydaDq74ixTmQS68qfeXyTOdSo8M/DaBA5Bh78=;
 b=FIlpBqZwj/3A0tCksE+4DSDLM/n7i/3slGK5HuQ8bgUCYggc1Ye/CTwjTxxo37SKZ3XuMbFI4BV9AOuJ6RRb9kA0U0DS/hs4ZT1XPrGNmUotpdhtXvAhSqNapKPc8X3LAoRPqe3LE2KhX3TNv3pApc0GMyEmLRruF95EA5tZcj/tzBHi5WIdw2l3CQDazaEwSI4riss2+5+9tBuIbVe7C7WNHOz4zdsU6mDz2/wfaAETqO7QItqLovJQqBLQGzWqa3jzgv/imEYlIbT5fb78q+hmT/kc3WpsKE2Lc5C6+UF4co2EF4qvfM2hxX6APccIeW6kLDocmAlg1CCB5qad8w==
Content-Disposition: inline
In-Reply-To: <YJzAsBNF1irJxRGg@yekko>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, May 13, 2021 at 04:01:20PM +1000, David Gibson wrote:

> But.. even if you're exposing page tables to userspace.. with hardware
> that has explicit support for nesting you can probably expose the hw
> tables directly which is great for the cases that works for.  But
> surely for older IOMMUs which don't do nesting you must have some way
> of shadowing guest IO page tables to host IO page tables to translate
> GPA to HPA at least?

I expect this would be in quemu and would be part of the expensive
emulation I suggested. Converting the guest's page table structure
into a sequence of map/unmaps to a non-nestable IOASID.

> If you're doing that, I don't see that converting page table format
> is really any harder

It isn't, but it is a completely different flow and custom from the
normal HW accelerated nesting.

> It might not be a theoretically complete emulation of the vIOMMU, but
> it can support in-practice usage.  In particular it works pretty well
> if your backend has a nice big IOVA range (like x86 IOMMUS) but your
> guest platform typically uses relatively small IOVA windows.  PAPR on
> x86 is exactly that... well.. possibly not the 64-bit window, but
> because of old PAPR platforms that didn't support that, we can choose
> not to advertise that and guests will cope.

So maybe this multi-window thing is generic API somehow. You'll have
to check what Kevin comes up with to ensure it fits in

Jason
