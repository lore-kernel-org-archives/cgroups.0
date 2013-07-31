From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] memcg: fix memcg resource limit overflow issues
Date: Wed, 31 Jul 2013 16:54:57 +0800
Message-ID: <51F8D0E1.4010007@huawei.com>
References: <1375255885-10648-1-git-send-email-h.huangqiang@huawei.com> <CAFj3OHX4WLaecyE_zFbnFKs9wrCWTq2eDAUDMxqPg8=TYt18gg@mail.gmail.com> <51F8D016.4090009@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51F8D016.4090009-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>, Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Jeff Liu <jeff.liu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

On 2013/7/31 16:51, Qiang Huang wrote:
> On 2013/7/31 16:23, Sha Zhengju wrote:
>> Hi list,
>>
>> On Wed, Jul 31, 2013 at 3:31 PM, Qiang Huang <h.huangqiang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org> wrote:
>>> This issue is first discussed in:
>>> http://marc.info/?l=linux-mm&m=136574878704295&w=2
>>>
>>> Then a second version sent to:
>>> http://marc.info/?l=linux-mm&m=136776855928310&w=2
>>>
>>> We contacted Sha a month ago, she seems have no time to deal with it
>>> recently, but we quite need this patch. So I modified and resent it.
>>
>>
>> No, I didn't receive any of YOUR message, only a engineer named Libo
>> Chen from Huawei connected me recently. I don't approve you to resent
>> them on behalf of me, and just before you send this you even don't
>> send me a mail. Besides, after a rough look, I do not see any
>> innovative ideas from yourself but just rework patches from my last
>> version.
>> So I'm strong against this patchset.
> 
> Sorry if this troubles you.
> Libo Chen is my colleague, we work together, he sent an email to you on
> 25 June, to ask about this issue, you said you'll resent it soon, but it
> didn't happen until now :(, and he asked again the other day and you didn't
> reply. As we really need to fix this problem(and need it in upstream), so
> I modified it and sent out.
> 
> I think split patches, rewrite changelogs and tests, they all kind of work
> right? Of course, if you mind, I can change it, I just need this fix merged
> to upstream ASAP.
> 
> So you want me rewrite this patchset and SOB only you or you want resent this
> by yourself? I'm ok with both :)
> 

No, you can't send out patches without your SOB...but you can add a line
in the beginning of the email:

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
