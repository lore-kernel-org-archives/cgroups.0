From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 09/12] sysfs: fix deadlock race with module removal
Date: Mon, 20 Sep 2021 14:36:38 -0700
Message-ID: <6db06c27-e3af-b0aa-6f38-9c31dd8194fa@acm.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
 <20210918050430.3671227-10-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20210918050430.3671227-10-mcgrof@kernel.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Luis Chamberlain <mcgrof@kernel.org>, tj@kernel.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org
Cc: rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@ACULAB.COM, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, daniel.vetter@ffwll.ch, bhelgaas@google.com, kw@linux.com, dan.j.williams@intel.com, senozhatsky@chromium.org, hch@lst.de

On 9/17/21 10:04 PM, Luis Chamberlain wrote:
> A sketch of how this can happen follows:
> 
> CPU A                              CPU B
>                                     whatever_store()
> module_unload
>    mutex_lock(foo)
>                                     mutex_lock(foo)
>     del_gendisk(zram->disk);
>       device_del()
>         device_remove_groups()
> 
> In this situation whatever_store() is waiting for the mutex foo to
> become unlocked, but that won't happen until module removal is complete.
> But module removal won't complete until the sysfs file being poked
> completes which is waiting for a lock already held.

If I remember correctly I encountered the deadlock scenario described
above for the first time about ten years ago while working on the SCST
project. We solved this deadlock by removing the sysfs attributes from
the module unload code before grabbing mutex_lock(foo), e.g. by calling
sysfs_remove_file(). This works because calling sysfs_remove_file()
multiple times in a row is safe. Is that solution good enough for the
zram driver?

Thanks,

Bart.
