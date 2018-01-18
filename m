From: David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH v6 00/99] XArray version 6
Date: Thu, 18 Jan 2018 17:56:12 +0100
Message-ID: <20180118165612.GS13726@twin.jikos.cz>
References: <20180117202203.19756-1-willy@infradead.org>
 <20180118160749.GP13726@twin.jikos.cz>
 <20180118164843.GA23800@bombadil.infradead.org>
Reply-To: dsterba@suse.cz
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:
 Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=PO+2jpOsb1Wnx39hhJM8wstqVCAy14M3p5iOD4MtqbY=; b=LaBB8k2Q4UZzleAwY2SI16mAKv
 66x4+DPFLK2d0j1iQ+yLKEepyl3yQkUVMfDriW823Rv1fRWKdyW38WwMbHMLIiebuAUUsekocMZs3
 uWeb6T/XVcDWV1pRqsUP69fKDu+7vKNFZjNhUOyeFPzzmuLkaFQ5yE4etaSPX5itwV+Y=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=In-Reply-To:Content-Type:MIME-Version:References:Reply-To:Message-ID:
 Subject:Cc:To:From:Date:Sender:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=PO+2jpOsb1Wnx39hhJM8wstqVCAy14M3p5iOD4MtqbY=; b=kNW4RSptexc3oprR8xGZ2uLBn5
 tqdYVL12oPNWGLVtmIC2OGHb39WVX1M5mI8SkM1Qh5c1vnE0Qg+AUMa1lCYQci37ToL3cuZ91bBQp
 UUORo/Od2oZxf2Z9uIRBm2D+PmhtL6pivGCLEROdSo87Z7TpAd5EL8Ch3gHVjSP9tHT4=;
Content-Disposition: inline
In-Reply-To: <20180118164843.GA23800@bombadil.infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, dsterba@suse.cz, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

On Thu, Jan 18, 2018 at 08:48:43AM -0800, Matthew Wilcox wrote:
> Thank you!  I shall attempt to debug.  Was this with a btrfs root
> filesystem?  I'm most suspicious of those patches right now, since they've
> received next to no testing.  I'm going to put together a smaller patchset
> which just does the page cache conversion and nothing else in the hope
> that we can get that merged this year.

No, the root is ext3 and there was no btrfs filesytem mounted at the
time.

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
