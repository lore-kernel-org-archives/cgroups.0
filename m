From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Mon, 20 Sep 2021 09:22:32 -1000
Message-ID: <YUjfeGuSVVq84iHc@mtj.duckdns.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
 <20210918050430.3671227-10-mcgrof@kernel.org>
 <YUjKjLzqpcxjRyit@slm.duckdns.org>
 <YUjdytEDkCughtSz@bombadil.infradead.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JRnq/4c87bKbiNxvafGN4wtXqF6Tb113NW1CCy3N52o=;
        b=dP4iFexr0a+J311K54uCPdaewF9LzVRZkY/aDH2dPD9xGtZMHeZBij8v6wTihEifkg
         bIk6GbffogctONMlgfddQ0fGCNpmpMWipeajx9Kyn00jXWS5Lh89zABYQjixzMBZ+eaL
         Z57MjvIXj5H4kS2oNAwGRXtw/nv8xi3stLkDBC0ZBQ8vdA44wM0qv9TgId7KYVrQFIIj
         r9NHcIiUB87XojT59VuOwo9LjdF4v5XE5loPh5rx3Uuhui2pBXa+MAb9l6U3Wrz/18ZN
         8IPl4GNh1/xWGwqjOGo2nh7ySRJNyY6KBJST84Cnz0eSywHu1cHrx+2hzcPKYFzGH1NN
         eH2g==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YUjdytEDkCughtSz@bombadil.infradead.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org, rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@i-love.sakura.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@aculab.com, bvanassche@acm.org, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmp

Hello,

On Mon, Sep 20, 2021 at 12:15:22PM -0700, Luis Chamberlain wrote:
> > I find this explanation odd because there's no real equivalent to locking
> > the module (as opposed to try locking) 
> 
> Actually there is, __module_get() but I suspect some of these users are
> probably incorrect and should be be moved to try. The documentation

__module_get() is just getting an extra ref when the caller already
has one (or more). It can't be used to freshly acquire a new
reference. There is no equivalence between the relationship between
try_module_get() and __module_get() and the one between spin_trylock()
and spin_lock().

> Right, the reason I mention the alternative is that we technically don't
> need to use try in this case since during a kernfs op it is implied the
> module will be pinned, but we have further motivations to use a try

I'm confused. If the module is already pinned, why are we getting an
extra reference? Also, I don't understand how this has that much to do
with preventing ddoses. I mean, it does cut down the duration of one
operation but the eventual gating is through whoever acquiring the
initial reference through try_module_get(), which again is the *only*
way to acquire a fresh reference.

Thanks.

-- 
tejun
