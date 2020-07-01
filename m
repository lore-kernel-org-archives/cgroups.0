From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] doc: cgroup: add f2fs and xfs to supported list for
 writeback
Date: Wed, 1 Jul 2020 09:32:24 +0100
Message-ID: <20200701083224.GI20101@infradead.org>
References: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
 <20200630054217.GA27221@infradead.org>
 <59265a9d-ee0f-4432-3f86-00d076aeb8e8@sandeen.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=vXiGSDx0OBTNUoDDVLCHJpE3R5npVOLQYlpMjYD89gk=; b=qdapIMox4Ek2eTE/n0txbbOjGF
        oJGKiOEgDQ9amafICkn7wMpGQazpixnCsCP9vzB1sWllWfYlQ8DIw/BDrv8it538xchboPP1a3fnT
        /r7lFtLJtFEe6qnkJAw62zmPT8rzrymyJ0nyAnw3cv66pExz0H6f2mtFbMKtbsSNR4N0LR36rhtwO
        F0i0ZUtDzzu+A9TrM/ZBHha+soKQAt4lO4WQQDJtMr2tjHFNu5+PkR/hO/DfBja+fSrsZGFpUIUZL
        IBFfzOqiowRXWGc4J2ORzoUaahAdW3PFVchNzsU3fVXrakWnQC9lWtXr6awjsuselgLhI1YRCo/YC
        rWe3CgMQ==;
Content-Disposition: inline
In-Reply-To: <59265a9d-ee0f-4432-3f86-00d076aeb8e8@sandeen.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Christoph Hellwig <hch@infradead.org>, Eric Sandeen <sandeen@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>

On Tue, Jun 30, 2020 at 08:59:34AM -0500, Eric Sandeen wrote:
> On 6/30/20 12:42 AM, Christoph Hellwig wrote:
> > On Mon, Jun 29, 2020 at 02:08:09PM -0500, Eric Sandeen wrote:
> >> f2fs and xfs have both added support for cgroup writeback:
> >>
> >> 578c647 f2fs: implement cgroup writeback support
> >> adfb5fb xfs: implement cgroup aware writeback
> >>
> >> so add them to the supported list in the docs.
> >>
> >> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> >> ---
> >>
> >> TBH I wonder about the wisdom of having this detail in
> >> the doc, as it apparently gets missed quite often ...
> > 
> > I'd rather remove the list of file systems.  It has no chance of
> > staying uptodate.
> 
> Is there any way for a user to know whether a filesytem does or doesn't
> support it, in practice?

git-grep SB_I_CGROUPWB
