From: Hou Tao <houtao-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: Re: [PATCH] blk-ioprio: Introduce promote-to-rt policy
Date: Fri, 3 Feb 2023 09:48:23 +0800
Message-ID: <beb7782e-72a4-c350-3750-23a767c88753@huaweicloud.com>
References: <20230201045227.2203123-1-houtao@huaweicloud.com>
 <8c068af3-7199-11cf-5c69-a523c7c22d9a@acm.org>
 <4f7dcb3e-2d5a-cae3-0e1c-a82bcc3d2217@huaweicloud.com>
 <b6b3c498-e90b-7d1f-6ad5-a31334e433ae@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b6b3c498-e90b-7d1f-6ad5-a31334e433ae-HInyCGIudOg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, houtao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hi Bart,

On 2/3/2023 2:05 AM, Bart Van Assche wrote:
> On 2/2/23 03:09, Hou Tao wrote:
>> Hi,
>>
>> On 2/2/2023 1:33 AM, Bart Van Assche wrote:
>>> On 1/31/23 20:52, Hou Tao wrote:
>>>>    /**
>>>>     * enum prio_policy - I/O priority class policy.
>>>>     * @POLICY_NO_CHANGE: (default) do not modify the I/O priority class.
>>>> @@ -27,21 +34,30 @@
>>>>     * @POLICY_RESTRICT_TO_BE: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_RT
>>>> into
>>>>     *        IOPRIO_CLASS_BE.
>>>>     * @POLICY_ALL_TO_IDLE: change the I/O priority class into
>>>> IOPRIO_CLASS_IDLE.
>>>> - *
>>>> + * @POLICY_PROMOTE_TO_RT: modify IOPRIO_CLASS_NONE and IOPRIO_CLASS_BE into
>>>> + *         IOPRIO_CLASS_RT.
>>>>     * See also <linux/ioprio.h>.
>>>>     */
>>>>    enum prio_policy {
>>>> -    POLICY_NO_CHANGE    = 0,
>>>> -    POLICY_NONE_TO_RT    = 1,
>>>> -    POLICY_RESTRICT_TO_BE    = 2,
>>>> -    POLICY_ALL_TO_IDLE    = 3,
>>>> +    POLICY_NO_CHANGE    = IOPRIO_CLASS_NONE,
>>>> +    POLICY_NONE_TO_RT    = IOPRIO_CLASS_RT,
>>>> +    POLICY_RESTRICT_TO_BE    = IOPRIO_CLASS_BE,
>>>> +    POLICY_ALL_TO_IDLE    = IOPRIO_CLASS_IDLE,
>>>> +    POLICY_PROMOTE_TO_RT    = IOPRIO_CLASS_RT | IOPRIO_POL_PROMOTION,
>>>> +};
>>>
>>> The above change complicates the ioprio code. Additionally, I'm concerned that
>>> it makes the ioprio code slower. Has it been considered to keep the numerical
>>> values for the existing policies, to assign the number 4 to
>>> POLICY_PROMOTE_TO_RT and to use a lookup-array in blkcg_set_ioprio() to
>>> convert the policy number into an IOPRIO_CLASS value?
>> For the slowness, do you meaning the extra dereference of blkcg->ioprio->policy
>> when policy is no-change or the handle of IOPRIO_POL_PROMOTION in
>> blkcg_set_ioprio()? It seems other functions (e.g., ioprio_show_prio_policy()
>> and ioprio_set_prio_policy()) are not on the hot path. Using a lookup array in
>> blkcg_set_ioprio() to do the conversion will also be OK, although it will
>> introduce an extra lookup each time when policy is not no-change. I don't have
>> strong preference. If you are OK with lookup array in blkcg_set_ioprio(), will
>> do it in v2.
>
> Hi Hou,
>
> I prefer the lookup array because with the lookup array approach the
> IOPRIO_POL_PROMOTION constant is no longer needed and because I expect that
> this will result in code that is easier to read. Additionally, the lookup
> array will be small so the compiler may be clever enough to optimize it away.
I don't get it on how to remove IOPRIO_POL_PROMOTION when calculating the final
ioprio for bio. IOPRIO_POL_PROMOTION is not used for IOPRIO_CLASS values but
used to determinate on how to calculate the final ioprio for bio: choosing the
maximum or minimum between blkcg ioprio and original bio bi_ioprio.
>
> Thanks,
>
> Bart.
>
>
> .

