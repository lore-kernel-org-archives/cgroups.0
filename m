From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v7 03/12] selftests: add tests_sysfs module
Date: Mon, 20 Sep 2021 14:38:02 -0700
Message-ID: <f33732f8-fd8e-abaf-6725-4a048bace2a2@acm.org>
References: <20210918050430.3671227-1-mcgrof@kernel.org>
 <20210918050430.3671227-4-mcgrof@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20210918050430.3671227-4-mcgrof@kernel.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Luis Chamberlain <mcgrof@kernel.org>, tj@kernel.org, gregkh@linuxfoundation.org, akpm@linux-foundation.org, minchan@kernel.org, jeyu@kernel.org, shuah@kernel.org
Cc: rdunlap@infradead.org, rafael@kernel.org, masahiroy@kernel.org, ndesaulniers@google.com, yzaikin@google.com, nathan@kernel.org, ojeda@kernel.org, penguin-kernel@I-love.SAKURA.ne.jp, vitor@massaru.org, elver@google.com, jarkko@kernel.org, glider@google.com, rf@opensource.cirrus.com, stephen@networkplumber.org, David.Laight@ACULAB.COM, jolsa@kernel.org, andriy.shevchenko@linux.intel.com, trishalfonso@google.com, andreyknvl@gmail.com, jikos@kernel.org, mbenes@suse.com, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com, reinette.chatre@intel.com, fenghua.yu@intel.com, bp@alien8.de, x86@kernel.org, hpa@zytor.com, lizefan.x@bytedance.com, hannes@cmpxchg.org, daniel.vetter@ffwll.ch, bhelgaas@google.com, kw@linux.com, dan.j.williams@intel.com, senozhatsky@chromium.org, hch@lst.de

On 9/17/21 10:04 PM, Luis Chamberlain wrote:
> +static void test_dev_config_lock(struct sysfs_test_device *test_dev)
> +{
> +	struct test_config *config;
> +
> +	config = &test_dev->config;

Please change the above into a single line (there are multiple
occurrences):

struct test_config *config = &test_dev->config;

Thanks,

Bart.
