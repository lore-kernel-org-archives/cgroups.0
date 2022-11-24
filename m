From: Kemeng Shi <shikemeng@huawei.com>
Subject: Re: [PATCH 08/11] blk-throttle: remove repeat check of elapsed time
 from last upgrade in throtl_hierarchy_can_downgrade
Date: Thu, 24 Nov 2022 20:58:10 +0800
Message-ID: <1f2bb84b-6c8b-aaf1-053a-46fe8c773767@huawei.com>
References: <20221123060401.20392-1-shikemeng@huawei.com>
 <20221123060401.20392-9-shikemeng@huawei.com>
 <Y35mXymUTC1lx50j@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y35mXymUTC1lx50j@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org



on 11/24/2022 2:28 AM, Tejun Heo wrote:
> On Wed, Nov 23, 2022 at 02:03:58PM +0800, Kemeng Shi wrote:
>>  static bool throtl_hierarchy_can_downgrade(struct throtl_grp *tg)
>>  {
>> +	if (time_before(now, tg->td->low_upgrade_time + td->throtl_slice))
>> +		return false;
> 
> Does this even build? Where is td defined?
Sorry for this mistake, CONFIG_BLK_DEV_THROTTLING_LOW seems not be set on
default. I will fix this and build with CONFIG_BLK_DEV_THROTTLING_LOW
set.

-- 
Best wishes
Kemeng Shi
