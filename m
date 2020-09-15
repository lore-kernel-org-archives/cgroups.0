From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v2 0/8] Return head pages from find_*_entry
Date: Tue, 15 Sep 2020 14:08:48 +0100
Message-ID: <20200915130848.GD5449@casper.infradead.org>
References: <20200910183318.20139-1-willy@infradead.org>
 <alpine.LSU.2.11.2009150059310.1550@eggly.anvils>
 <CA+G9fYvqbKPHoYbU7w2bPkOF_vgbYgEHavLDxXQ4O5xUFHGCuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
 References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
 Content-Transfer-Encoding:Content-ID:Content-Description;
 bh=7NBf7Gx3NEoEBeWF+X5RA2TyfqQ9s1ho0GYQa3vJ+Jk=; b=ZO9myoY4N8MfiF8r9ZsvVUTGB0
 OpnTN/gQGj4PpxFg8LiE+oarC9K2KzEtQiyaBPyHtovx7UQS5tW+8bfbZDtPpgRuvDKMNJaZJbnec
 DrMTvRg1f1Te744UlXOkbnaopigPono/kBlyjwnNfR0ZoKnhZnaFfm2koAZUL1lyoGn01IeqbSwFC
 yDxXO8ABXfJxT5Vh8Kv5VpEcNU5zbsf0MhVPYtVLKyR8o2A2dpQz9WFvK8WbHRf/K1mH/HftDS0+k
 XVucUsuZ1mjpTCkcuCujL50iA09RUSUuTMire+garHju3WRwUpM7Qwp53r2bIHF2mw1nW9mACo6pG
 7bLfhU2w==;
Content-Disposition: inline
In-Reply-To: <CA+G9fYvqbKPHoYbU7w2bPkOF_vgbYgEHavLDxXQ4O5xUFHGCuw@mail.gmail.com>
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
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, William Kucharski <william.kucharski@oracle.com>, intel-gfx@lists.freedesktop.org, Huang Ying <ying.huang@intel.com>, Hugh Dickins <hughd@google.com>, open list <linux-kernel@vger.kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, linux-mm <linux-mm@kvack.org>, Linux-Next Mailing List <linux-next@vger.kernel.org>, Matthew Auld <matthew.auld@intel.com>, lkft-triage@lists.linaro.org, Johannes Weiner <hannes@cmpxchg.org>, Cgroups <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, ricardo.canuelo@collabora.com, Alexey Dobriyan <adobriyan@gmail.com>

On Tue, Sep 15, 2020 at 06:23:27PM +0530, Naresh Kamboju wrote:
> While running kselftest mincore tests the following kernel BUG reported on the
> linux next-20200915 tag on x86_64, i386 and arm64.

https://lore.kernel.org/linux-mm/20200914112738.GM6583@casper.infradead.org/
