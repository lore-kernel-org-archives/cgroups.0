From: Sha Zhengju <handai.szj@gmail.com>
Subject: Re: [PATCH V5 0/8] Add memcg dirty/writeback page accounting
Date: Sat, 3 Aug 2013 17:30:26 +0800
Message-ID: <CAFj3OHUy=w=CJkFZ7QLWRS7-UOm0AA5n07Ykzb4wtd6VZ4k9tw@mail.gmail.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
	<20130801144326.GI5198@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=4Gj2bJjBNnt01Qx7RxwIJ/ibx3kRgvfPxdnkWFQi5LE=;
        b=j5y7q/T2roy7+MqXwZOOipT+O/GNjDgpvfdc0Qk2M5/LT+n/jZMaEZLlO29yyzr2on
         YXU59jdes61w5PSIWP74E+niM7j0V4SAGDvFnCHQ+4hsBc88b3lW+8tp62MA70c0/u4T
         UEuotN5hK6KITIPUiLMWP24s19U/RfPBHTiEsOE9EADT3GYr7OeqfmSjLX4GV/xfbI97
         XDBYiYFJBUoiRvv54EPpHHa9MDEBVX1dWK93n5JP2PO9Ntqb4qQxbVRzYHhtuFqOoZoB
         PqvBa3A/ZveZAhYwBm5TQVrPqRBOTSjbyVcwAhs8xqLBVK2HzucC+GMP/pdh/WT+AN6D
         bNcw==
In-Reply-To: <20130801144326.GI5198@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Glauber Costa <glommer@gmail.com>, Greg Thelen <gthelen@google.com>, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Sha Zhengju <handai.szj@taobao.com>

On Thu, Aug 1, 2013 at 10:43 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Thu 01-08-13 19:43:22, Sha Zhengju wrote:
> [...]
>> Some perforcemance numbers got by Mel's pft test (On a 4g memory and 4-core
>> i5 CPU machine):
>
> I am little bit confused what is this testcase actually testing... AFAIU
> it produces a lot of page faults but they are all anonymous and very
> short lived. So neither dirty nor writeback accounting is done.
>
> I would have expected a testcase which generates a lot of IO.

I see. I'm always not good at testing. :(

>
> Also as a general note. It would be better to mention the number of runs
> and standard deviation so that we have an idea about variability of the
> load.

OK. Thanks for the notes!

>
>> vanilla  : memcg enabled, patch not applied
>> patched  : all patches are patched
>>
>> * Duration numbers:
>>              vanilla     patched
>> User          385.38      379.47
>> System         65.12       66.46
>> Elapsed       457.46      452.21
>>
>> * Summary numbers:
>> vanilla:
>> Clients User        System      Elapsed     Faults/cpu  Faults/sec
>> 1       0.03        0.18        0.21        931682.645  910993.850
>> 2       0.03        0.22        0.13        760431.152  1472985.863
>> 3       0.03        0.29        0.12        600495.043  1620311.084
>> 4       0.04        0.37        0.12        475380.531  1688013.267
>>
>> patched:
>> Clients User        System      Elapsed     Faults/cpu  Faults/sec
>> 1       0.02        0.19        0.22        915362.875  898763.732
>> 2       0.03        0.23        0.13        757518.387  1464893.996
>> 3       0.03        0.30        0.12        592113.126  1611873.469
>> 4       0.04        0.38        0.12        472203.393  1680013.271
>>
>> We can see the performance gap is minor.
> [...]
> --
> Michal Hocko
> SUSE Labs



-- 
Thanks,
Sha

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
