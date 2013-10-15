From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Possible regression with cgroups in 3.11
Date: Tue, 15 Oct 2013 11:15:03 +0800
Message-ID: <525CB337.8050105@huawei.com>
References: <4431690.ZqnBIdaGMg@akheu22.uni-muenster.de> <5257F7CE.90702@huawei.com> <CA+SBX_Pa8sJbRq3aOghzqam5tDUbs_SPnVTaewtg-pRmvUqSzA@mail.gmail.com> <5258E584.70500@huawei.com> <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+SBX_MQVMuzWKroASK7Cr5J8cu9ajGo=CWr7SRs+OWh83h4_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Markus Blank-Burian <burian-iYtK5bfT9M8b1SvskN2V4Q@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2013/10/14 16:06, Markus Blank-Burian wrote:
> The crash utility indicated, that the lock was held by a kworker
> thread, which was idle at the moment. So there might be a case, where
> no unlock is done. I am trying to reproduce the problem at the moment
> with CONFIG_PROVE_LOCKING, but without luck so far. It seems, that my
> test-job is quite bad at reproducing the bug. I'll let you know, if I
> can find out more.
> 

Thanks. I'll review the code to see if I can find some suspect.

PS: I'll be travelling from 10/16 ~ 10/28, so I may not be able
to spend much time on this.
