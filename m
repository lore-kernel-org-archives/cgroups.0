From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 5/8] i915: Use find_lock_page instead of
 find_lock_entry
Date: Wed, 26 Aug 2020 10:27:03 -0400
Message-ID: <20200826142703.GD988805@cmpxchg.org>
References: <20200819184850.24779-1-willy@infradead.org>
 <20200819184850.24779-6-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <intel-gfx-bounces@lists.freedesktop.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=xk5PuaZ3h09SHfotxUuVEcyrelgIx31zSBn5gXVN9IM=;
 b=OF5msf8xUCmN3Dyr5IsRi7XjXqiObhM2vxPE0Wx6z73yQzocQZyXZsVr5xG0GxVewc
 8mLHzkVTThC3XbmKu2Oa0VF7cELOHQSCp/cqw+5vpnsG3VZHJvXAr+JOvrRE6R63MecR
 5eKN8lU7SEwLqjplk8sot+PoejbjUxEv8shqxLgH73nW3b2ndtpOW1dPSVhhoQHC5XxK
 PdD3gTbsv7nty7LeKQllTit9Ov259nDQt7vZU9yH1d6KPkehzqy90/rxUJUFDOLY8VkC
 R2+yVQgS7FhIexvx3CAo8IWgUcOwpwxqj9aIgTPNL0TCgX8H7T0yWCtFyDa7/BtXGVhx
 sMNA==
Content-Disposition: inline
In-Reply-To: <20200819184850.24779-6-willy@infradead.org>
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

On Wed, Aug 19, 2020 at 07:48:47PM +0100, Matthew Wilcox (Oracle) wrote:
> i915 does not want to see value entries.  Switch it to use
> find_lock_page() instead, and remove the export of find_lock_entry().
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
