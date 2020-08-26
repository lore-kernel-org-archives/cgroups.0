From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/8] mm: Optimise madvise WILLNEED
Date: Wed, 26 Aug 2020 10:23:15 -0400
Message-ID: <20200826142315.GB988805@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-4-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=zlwE58oTu+f+CX5TRYYwuWXiyc0+G6WkfNqbI/+jdSY=;
 b=cO+CBnh7nK5+bWxbN/rwQcj2H4qISpWSCtom8J3NYKwbjjXE4VHyCPU6l4SYsLNQmS
 /WI/E5HAG6u+MoAcxZo9egIz5wDe5DDX4DfqLRODmFk9MExnxgPzPF23yCNm1kB3cvoV
 JoRLPo24DnMgbfUAXBvkX2DO0dxWBYMNrm5mIDfNk6jWm/45g4hZat1hwqysM8GfOXFX
 0R9ZwQfqa5GixPcfpxcCrt6oIcNXd+0bZ32ZYNKsPrbRA29tlAUFbv+RobCsikP15Xj7
 ssAysz8PU4hvGQHGShDiRr1e+3BKKvfW+PrqfNf1IzlNtqHYDXkI1vnfAQh1X9s1Ugev
 bVmw==
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-4-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/intel-gfx>
List-Post: <mailto:intel-gfx@lists.freedesktop.org>
List-Help: <mailto:intel-gfx-request@lists.freedesktop.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/intel-gfx>,
 <mailto:intel-gfx-request@lists.freedesktop.org?subject=subscribe>
Errors-To: intel-gfx-bounces@lists.freedesktop.org
Sender: "Intel-gfx" <intel-gfx-bounces@lists.freedesktop.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm@kvack.org, Matthew Auld <matthew.auld@intel.com>, Huang Ying <ying.huang@intel.com>, cgroups@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Alexey Dobriyan <adobriyan@gmail.com>

On Wed, Aug 19, 2020 at 07:48:45PM +0100, Matthew Wilcox (Oracle) wrote:
> Instead of calling find_get_entry() for every page index, use an XArray
> iterator to skip over NULL entries, and avoid calling get_page(),
> because we only want the swap entries.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
