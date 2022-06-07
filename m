From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Tue, 7 Jun 2022 19:51:20 +0800
Message-ID: <9a51c7b1-ba6c-0a56-85cf-5e602b9c6ec2@huawei.com>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
 <20220523085902.wmxoebyq3crerecr@quack3.lan>
 <25f6703e-9e10-75d9-a893-6df1e6b75254@kernel.dk>
 <20220523152516.7sr247i3bzwhr44w@quack3.lan>
 <21cd1c49-838a-7f03-ab13-9a4f2ac65979@huawei.com>
 <20220607095430.kac5jgzm2gvd7x3c@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220607095430.kac5jgzm2gvd7x3c-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

在 2022/06/07 17:54, Jan Kara 写道:
> On Tue 07-06-22 11:10:27, Yu Kuai wrote:
>> 在 2022/05/23 23:25, Jan Kara 写道:
>>> Hum, for me all emails from Huawei I've received even today fail the DKIM
>>> check. After some more digging there is interesting inconsistency in DMARC
>>> configuration for huawei.com domain. There is DMARC record for huawei.com
>>> like:
>>>
>>> huawei.com.		600	IN	TXT	"v=DMARC1;p=none;rua=mailto:dmarc-8cQ/FyLJEfGM2ScGVVA7yQ@public.gmane.org"
>>>
>>> which means no DKIM is required but _dmarc.huawei.com has:
>>>
>>> _dmarc.huawei.com.	600	IN	TXT	"v=DMARC1;p=quarantine;ruf=mailto:dmarc-hv44wF8Li93QT0dZR+AlfA@public.gmane.org;rua=mailto:dmarc-hv44wF8Li93QT0dZR+AlfA@public.gmane.org"
>>>
>>> which says that DKIM is required. I guess this inconsistency may be the
>>> reason why there are problems with DKIM validation for senders from
>>> huawei.com. Yu Kuai, can you perhaps take this to your IT support to fix
>>> this? Either make sure huawei.com emails get properly signed with DKIM or
>>> remove the 'quarantine' record from _dmarc.huawei.com. Thanks!
>>>
>>> 								Honza
>>>
>> Hi, Jan and Jens
>>
>> I just got response from our IT support:
>>
>> 'fo' is not set in our dmarc configuration(default is 0), which means
>> SPF and DKIM verify both failed so that emails will end up in spam.
>>
>> It right that DKIM verify is failed because there is no signed key,
>> however, our IT support are curious how SPF verify faild.
>>
>> Can you guys please take a look at ip address of sender? So our IT
>> support can take a look if they miss it from SPF records.
> 
> So SPF is what makes me receive direct emails from you. For example on this
> email I can see:
> 
> Received: from frasgout.his.huawei.com (frasgout.his.huawei.com
>          [185.176.79.56])
>          (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128
>          bits))
>          (No client certificate requested)
>          by smtp-in2.suse.de (Postfix) with ESMTPS id 4LHFjN2L0dzZfj
>          for <jack-AlSwsSmVLrQ@public.gmane.org>; Tue,  7 Jun 2022 03:10:32 +0000 (UTC)
> ...
> Authentication-Results: smtp-in2.suse.de;
>          dkim=none;
>          dmarc=pass (policy=quarantine) header.from=huawei.com;
>          spf=pass (smtp-in2.suse.de: domain of yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org designates
>          185.176.79.56 as permitted sender) smtp.mailfrom=yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
> 
> So indeed frasgout.his.huawei.com is correct outgoing server which makes
> smtp-in2.suse.de believe the email despite missing DKIM signature. But the
> problem starts when you send email to a mailing list. Let me take for
> example your email from June 2 with Message-ID
> <20220602082129.2805890-1-yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, subject "[PATCH -next]
> mm/filemap: fix that first page is not mark accessed in filemap_read()".
> There the mailing list server forwards the email so we have:
> 
> Received: from smtp-in2.suse.de ([192.168.254.78])
>          (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
>          by dovecot-director2.suse.de with LMTPS
>          id 8MC5NfVvmGIPLwAApTUePA
>          (envelope-from <linux-fsdevel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>)
>          for <jack-j1pC+zEt+uWoYr4blSSd5g@public.gmane.org>; Thu, 02 Jun 2022 08:08:21 +0000
> Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
>          by smtp-in2.suse.de (Postfix) with ESMTP id 4LDJYK5bf0zZg5
>          for <jack-AlSwsSmVLrQ@public.gmane.org>; Thu,  2 Jun 2022 08:08:21 +0000 (UTC)
> Received: (majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org) by vger.kernel.org via listexpand
>          id S232063AbiFBIIM (ORCPT <rfc822;jack-AlSwsSmVLrQ@public.gmane.org>);
>          Thu, 2 Jun 2022 04:08:12 -0400
> Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56178 "EHLO
>          lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by
>          vger.kernel.org
>          with ESMTP id S232062AbiFBIIL (ORCPT
>          <rfc822;linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>);
>          Thu, 2 Jun 2022 04:08:11 -0400
> Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
>          by lindbergh.monkeyblade.net (Postfix) with ESMTPS id
>          75DDB25FE;
>          Thu,  2 Jun 2022 01:08:08 -0700 (PDT)
> 
> and thus smtp-in2.suse.de complains:
> 
> Authentication-Results: smtp-in2.suse.de;
>          dkim=none;
>          dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM"
>          header.from=huawei.com (policy=quarantine);
>          spf=pass (smtp-in2.suse.de: domain of
>          linux-fsdevel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org designates 2620:137:e000::1:20 as
>          permitted sender) smtp.mailfrom=linux-fsdevel-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> 
> Because now we've got email with "From" header from huawei.com domain from
> a vger mail server which was forwarding it. So SPF has no chance to match
> (in fact SPF did pass for the Return-Path header which points to
> vger.kernel.org but DMARC defines that if "From" and "Return-Path" do not
> match, additional validation is needed - this is the "SPF not aligned
> (relaxed)" message above). And missing DKIM (the additional validation
> method) sends the email to spam.

Thanks a lot for your analysis, afaics, in order to fix the
problem, either your mail server change the configuration to set
alignment mode to "relaxed" instead of "strict", or our mail server
add correct DKIM signature for emails.

I'll contact with our IT support and try to add DKIM signature.

Thanks,
Kuai
