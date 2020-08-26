From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 6/8] mm: Convert find_get_entry to return
 the head page
Date: Wed, 26 Aug 2020 11:09:25 -0400
Message-ID: <20200826150925.GE988805@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-7-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=vg8N6XsbIE7lvZX/pCZOFe+OtpGR0YWlM+DD8uHDUGQ=;
 b=VAOKpGG4Zi1L0nHk3pQChVy6LRCqLG0qD/7fwLdWBi9XbsPa+O7Uq2p7C7i1gtvxuF
 yUiWcAjIIr7W3J71zlqtWD7t2XecOSMv4Z8Vo9D22AEnwSYBdhp9bLlcsTyqyVT0PkOm
 6lQsFFPn4vjC5shx4wLOdylw9FIQcFWlFd3ZTCqMXpqDORJ6S0UXlw3Q0fAoeya9nGcK
 3KyT/337ybzoMJsqTLWcEEqoUj/7b0O+aIgq4feNby+j5A3AAgkMjCFhu93HxCQ+qRgQ
 M0iItYBDqEZWD0cxnCQ3JfuMG9LqTb1O1DvejdQunzJkmhaRRPNY6924yuSU0CZRbhW2
 Mkqg==
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-7-willy@infradead.org>
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

On Wed, Aug 19, 2020 at 07:48:48PM +0100, Matthew Wilcox (Oracle) wrote:
> There are only three callers remaining of find_get_entry().
> find_get_swap_page() is happy to get the head page instead of the subpage.
> Add find_subpage() calls to find_lock_entry() and pagecache_get_page()
> to avoid auditing all their callers.

I believe this would cause a subtle bug in memcg charge moving for pte
mapped huge pages. We currently skip over tail pages in the range
(they don't have page->mem_cgroup set) and account for the huge page
once from the headpage. After this change, we would see the headpage
and account for it 512 times (or whatever the number is on non-x86).

But that aside, I don't quite understand the intent.

Before, all these functions simply return the base page at @index,
whether it's a regular page or a tail page.

Afterwards, find_lock_entry(), find_get_page() et al still do, but
find_get_entry() returns headpage at @index & HPAGE_CACHE_INDEX_MASK.

Shouldn't we be consistent about how we handle huge pages when
somebody queries the tree for a given base page index?

[ Wouldn't that mean that e.g. find_get_swap_page() would return tail
  pages for regular files and head pages for shmem files? ]
