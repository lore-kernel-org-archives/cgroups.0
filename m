From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [PATCH v3 10/10] sched/psi: per-cgroup PSI accounting
 disable/re-enable interface
Date: Thu, 25 Aug 2022 21:29:48 +0800
Message-ID: <5165abfc-9f42-93ea-a888-11eaa4ab3420@bytedance.com>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-11-zhouchengming@bytedance.com>
 <YwX2jC2UQ/zeY2E8@cmpxchg.org>
 <324b1d0f-42e5-8947-68cb-a3d20135f2c6@bytedance.com>
 <Ywd3K1+5blotUEtU@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=dTFw9x7UWEYWmcpi8QQ3ADKhSd2hLCnt4Nb7ZML9r2c=;
        b=pOJV7py+1gmdPby1+qgIJXeyyz4vq0Y6SLPWPk9C8wUZ3jbdpsjj+uYWZc4U5ah1p+
         yuDLAenPGiZt6i2y5O9Yjy3d+66C3b0XSxLsquozHv/qZWsspon/9kgcx0Slj2iTSp1k
         tf1pbn+dGkU5JKNE6CsKL0XkZsCaDBaP57N3oUk7avUm45JecCZgR0w917DxONm4foP9
         xOgSNwfIZVy54TaQXWB3pMJ3kszwkTpW+JZncbc3bnLEpumsNiR5JaB77HhsTQGz+MOu
         ozcglXwiMk+OTMLGHZ8euypblNhMuH8XJxn2qewzILgRw3UqQ1IkQCC86Z7Hg5aEY57Y
         POfQ==
Content-Language: en-US
In-Reply-To: <Ywd3K1+5blotUEtU@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: tj@kernel.org, mkoutny@suse.com, surenb@google.com, gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On 2022/8/25 21:20, Johannes Weiner wrote:
> On Thu, Aug 25, 2022 at 08:28:39PM +0800, Chengming Zhou wrote:
>> On 2022/8/24 17:59, Johannes Weiner wrote:
>>> Hi Chengming,
>>>
>>> Thanks for incorporating all the feedback. I have a few nitpicks
>>> below, but with those considered, please add:
>>>
>>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
>>>
>>> On Wed, Aug 24, 2022 at 04:18:29PM +0800, Chengming Zhou wrote:
>>>> @@ -5171,12 +5220,19 @@ static struct cftype cgroup_base_files[] = {
>>>>  	{
>>>>  		.name = "irq.pressure",
>>>>  		.flags = CFTYPE_PRESSURE,
>>>> +		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
>>>>  		.seq_show = cgroup_irq_pressure_show,
>>>>  		.write = cgroup_irq_pressure_write,
>>>>  		.poll = cgroup_pressure_poll,
>>>>  		.release = cgroup_pressure_release,
>>>>  	},
>>>>  #endif
>>>> +	{
>>>> +		.name = "cgroup.pressure",
>>>> +		.flags = CFTYPE_PRESSURE,
>>>> +		.seq_show = cgroup_psi_show,
>>>> +		.write = cgroup_psi_write,
>>>
>>> To match the naming convention, these should be called
>>> cgroup_pressure_show() and cgroup_pressure_write().
>>
>> I just find cgroup_pressure_write() already exists, so I change the names
>> to cgroup_pressure_enable_show() and cgroup_pressure_enable_write(),
>> since this file name is simplified from "cgroup.pressure.enable".
> 
> That makes two outliers instead of one. It's probably better to steal
> cgroup_pressure_write for cgroup.pressure, and rename the currently
> misnamed helper. How about do_pressure_write()? pressure_write()?

Ok, I will change that helper to pressure_write().

Thanks.

