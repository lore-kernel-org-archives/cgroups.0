From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v13 15/18] mm/memcg: Add folio_lruvec()
Date: Tue, 13 Jul 2021 14:02:04 +0100
Message-ID: <YO2OzFbjYLjd7WkD@infradead.org>
References: <20210712194551.91920-1-willy@infradead.org>
 <20210712194551.91920-16-willy@infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=QTFWZ70fPTxxGEfvpW72iHrISZ3ROumWvX7+BCwkJ0E=; b=WpZY2MwAsMub0Dpyaxn+R4FRAo
        WgnNZJlWVxz5235Wc62HNNBkKgC0R28TaOahiPk8q/dWIx3h1KiplTIONREJFaRDQdKs+aGRZyoNu
        OU9h3YiS2XtS0Cv3S2EGJBjoM3MeKEpXZ9D+NpUz/h0VN/80t1ai8S3AspZs2LXny6NITrT97g+T6
        SSsoraYw1DjXzAZ1fCNugbAbMVv7HTIU1NNDptus1BhndrabfeUR6OxcjAbyTDxK+nAqvmleK+Q+2
        TZdxfMhdz5W0KEQFS2WWI1Yb6EIHkMo1pt81H0JCYZBr3EaKfFf5fTqlWWBQS3i5OUfVhz9CCFwPC
        PHSeeC4Q==;
Content-Disposition: inline
In-Reply-To: <20210712194551.91920-16-willy@infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Mon, Jul 12, 2021 at 08:45:48PM +0100, Matthew Wilcox (Oracle) wrote:
> This replaces mem_cgroup_page_lruvec().  All callers converted.

Looks good, especially as it doesn't have much to do with
cgroups except as an implementation detail.  Shouldn't this
function also move out of memcontrol.h eventually?

Reviewed-by: Christoph Hellwig <hch@lst.de>
