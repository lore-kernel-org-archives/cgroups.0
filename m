From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 22 Jun 2023 08:09:03 -0600
Message-ID: <0d6377ef-bc34-784a-8694-478d0ade085e@embeddedor.com>
References: <ZIpm3pcs3iCP9UaR@work>
 <726aae97-755d-9806-11d4-2fb21aa93428@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=o3nVrYc6RnMxf0e4iXIYtKi5C8Jg0CJJ5aA5IElG1J4=; b=NgA+pmIXcZG44sheyyW+4X1RXY
        smpeQnJ51qjrJ/tGhVsmFIqY7x6nBKhE8k6xCuSipNQc1IP19DirM4La5M1Ge9T6pbANFk6+/t0B1
        M4kqNHjb02rpzZI6hy/+OCv693WiSmAdv7SI4hSMAKhh6LT3laJeSStXoI+jMknLTGdPu0Y6j+k5M
        u3NY4wbs3bt0hYozTpgWxUOkcZKN6k53nBBJ3279HPdS3HH3D4WbFAfUcDGguMvJZhavp9U1IXX1P
        27FMwsTERckNPsUodrrztxoo9JNMj78L+9fXGe3UK2ZaViArNdjSUuqZ/TkhIwyP8BCdYgaWQf1Iy
        Jm3+ 
Content-Language: en-US
In-Reply-To: <726aae97-755d-9806-11d4-2fb21aa93428@arm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Steven Price <steven.price@arm.com>, "Gustavo A. R. Silva" <gustavoars@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>

Hi!

On 6/22/23 04:11, Steven Price wrote:
> On 15/06/2023 02:18, Gustavo A. R. Silva wrote:
>> Address the following -Wstringop-overflow warnings seen when
>> built with ARM architecture and aspeed_g4_defconfig configuration
>> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
>> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
>>
>> These changes are based on commit d20d30ebb199 ("cgroup: Avoid compiler
>> warnings with no subsystems").
>>
>> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
>> ---
>>   kernel/cgroup/cgroup.c | 6 ++++++
>>   1 file changed, 6 insertions(+)
>>
>> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
>> index cd497b90e11a..1ee76e62eb98 100644
>> --- a/kernel/cgroup/cgroup.c
>> +++ b/kernel/cgroup/cgroup.c
>> @@ -1200,6 +1200,9 @@ static struct css_set *find_css_set(struct css_set *old_cset,
>>   	unsigned long key;
>>   	int ssid;
>>   
>> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
>> +		return NULL;
>> +
>>   	lockdep_assert_held(&cgroup_mutex);
>>   
>>   	/* First see if we already have a cgroup group that matches
>> @@ -6045,6 +6048,9 @@ int __init cgroup_init(void)
>>   	struct cgroup_subsys *ss;
>>   	int ssid;
>>   
>> +	if (!CGROUP_HAS_SUBSYS_CONFIG)
>> +		return -EINVAL;
>> +
>>   	BUILD_BUG_ON(CGROUP_SUBSYS_COUNT > 16);
>>   	BUG_ON(cgroup_init_cftypes(NULL, cgroup_base_files));
>>   	BUG_ON(cgroup_init_cftypes(NULL, cgroup_psi_files));
> 
> This change (which landed in linux-next) causes a boot failure on my
> (arm32) board because the cgroup filesystem isn't created which upsets
> systemd:
> 
> [   11.474767] systemd[1]: Failed to mount tmpfs at /sys/fs/cgroup: No such file or directory
> [   11.489933] systemd[1]: Failed to mount cgroup at /sys/fs/cgroup/systemd: No such file or directory
> [!!!!!!] Failed to mount API filesystems.
> 
> Reverting this commit on the head of linux-next gets the board working
> again.

Thanks for reporting this issue. I'll take a look.

--
Gustavo
