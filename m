From: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>
Subject: Re: [PATCH] cpuset: Remove stale URLs in the MAINTAINERS entry
Date: Mon, 4 Jan 2021 09:28:38 -0600
Message-ID: <20210104152838.GA144275@swahl-home.5wahls.com>
References: <42668f2c-5ea1-da38-918e-ac4c86e3f03d@huawei.com>
 <2822d565280536f36ea6ddd521a7716813ef85a2.camel@perches.com>
 <39449cc4-15bf-4570-2bbd-dd47ea73b86c@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pps0720; bh=AVQahVYreNEK2Vi11CqdSHwDA2Hdtxm2MaBe4FwYlI8=;
 b=O5qEQ6UAoJ1kVi7bxCgrf2pfAD3imhJuo3RzADBDyQacBccCxMd/r7dDZTiUhf5Kh1ug
 9fstrHPyvmKSETMi8wcLIqQ3/14I4D6nTgM7TlF2ufJuq+pVdwoTNGH3iuCSOveNgcA3
 /9kwdkVhP0l98NCVBkHLf9KWf4Ln77vMuG4/Btr/YnpwhFAOyOp3k/0N1WwVCuqe2DQV
 8Eb9zgUzn6ZebrC2jwXXnVPAZQuB+RAsk1QIvMgnp7/EoXmKE2ruilUZYapxX4x5z2WQ
 j48uk4iiqqB3he7H7r8Wnd4uBH7SUUiqDusODy1Pj9ksS6lRhYSV+EFqwvScwNFGDU1z nw== 
Content-Disposition: inline
In-Reply-To: <39449cc4-15bf-4570-2bbd-dd47ea73b86c-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>

On Mon, Dec 28, 2020 at 02:31:52PM +0800, Zefan Li wrote:
> On 2020/12/28 14:01, Joe Perches wrote:
> > On Mon, 2020-12-28 at 11:17 +0800, Zefan Li wrote:
> >> Those URLs are no longer accessable.
> > 
> > The general argument to avoid removal of these no longer valid links
> > is that they may still be available from archive.org.
> > 
> > ...
> > 
> > It may be appropriate to copy the content into a local Documentation
> > file somewhere to avoid the need to lookup old reference links.
> > 
> 
> I don't think the contents in those links provide valuable information about cpusets.
> We have documents in Documentation/admin-guide/cgroup/ and man cpuset(7). So I think
> we can just remove them.

I agree, I did the archive.org lookup and it appeared that the current
version of most of this information is already under the Documentation
tree.

--> Steve

-- 
Steve Wahl, Hewlett Packard Enterprise
