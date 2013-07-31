From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: [PATCH 0/4] memcg: fix memcg resource limit overflow issues
Date: Wed, 31 Jul 2013 17:34:22 +0800
Message-ID: <51F8DA1E.3040900@oracle.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com> <CAFj3OHX4WLaecyE_zFbnFKs9wrCWTq2eDAUDMxqPg8=TYt18gg@mail.gmail.com> <51F8D016.4090009@huawei.com> <51F8D0E1.4010007@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51F8D0E1.4010007@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: Qiang Huang <h.huangqiang@huawei.com>, Sha Zhengju <handai.szj@gmail.com>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Sha Zhengju <handai.szj@taobao.com>, Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>

On 07/31/2013 04:54 PM, Li Zefan wrote:

> On 2013/7/31 16:51, Qiang Huang wrote:
>> On 2013/7/31 16:23, Sha Zhengju wrote:
>>> Hi list,
>>>
>>> On Wed, Jul 31, 2013 at 3:31 PM, Qiang Huang <h.huangqiang@huawei.com> wrote:
>>>> This issue is first discussed in:
>>>> http://marc.info/?l=linux-mm&m=136574878704295&w=2
>>>>
>>>> Then a second version sent to:
>>>> http://marc.info/?l=linux-mm&m=136776855928310&w=2
>>>>
>>>> We contacted Sha a month ago, she seems have no time to deal with it
>>>> recently, but we quite need this patch. So I modified and resent it.
>>>
>>>
>>> No, I didn't receive any of YOUR message, only a engineer named Libo
>>> Chen from Huawei connected me recently. I don't approve you to resent
>>> them on behalf of me, and just before you send this you even don't
>>> send me a mail. Besides, after a rough look, I do not see any
>>> innovative ideas from yourself but just rework patches from my last
>>> version.
>>> So I'm strong against this patchset.
>>
>> Sorry if this troubles you.
>> Libo Chen is my colleague, we work together, he sent an email to you on
>> 25 June, to ask about this issue, you said you'll resent it soon, but it
>> didn't happen until now :(, and he asked again the other day and you didn't
>> reply. As we really need to fix this problem(and need it in upstream), so
>> I modified it and sent out.
>>
>> I think split patches, rewrite changelogs and tests, they all kind of work
>> right? Of course, if you mind, I can change it, I just need this fix merged
>> to upstream ASAP.
>>
>> So you want me rewrite this patchset and SOB only you or you want resent this
>> by yourself? I'm ok with both :)
>>
> 
> No, you can't send out patches without your SOB...but you can add a line
> in the beginning of the email:
> 
> From: Sha Zhengju <handai.szj@taobao.com>

This is the usual way to credit the original author.  But in this case, Qiang
should get a confirmation from Sha at first.

IMO, that would make a mess of a project if anybody can take over an on-going
task without an approval from the author just because he is looking forward to
see something will happen on mainline shortly.

Thanks,
-Jeff

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
