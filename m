From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Tue, 7 Jun 2022 11:10:27 +0800
Message-ID: <21cd1c49-838a-7f03-ab13-9a4f2ac65979@huawei.com>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
 <20220523085902.wmxoebyq3crerecr@quack3.lan>
 <25f6703e-9e10-75d9-a893-6df1e6b75254@kernel.dk>
 <20220523152516.7sr247i3bzwhr44w@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20220523152516.7sr247i3bzwhr44w-/1kMjMImKQN+urZeOPWqwQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>



=D4=DA 2022/05/23 23:25, Jan Kara =D0=B4=B5=C0:
> On Mon 23-05-22 06:36:58, Jens Axboe wrote:
>> On 5/23/22 2:59 AM, Jan Kara wrote:
>>> On Mon 23-05-22 09:10:38, yukuai (C) wrote:
>>>> ? 2022/05/21 20:21, Jens Axboe ??:
>>>>> On 5/21/22 1:22 AM, yukuai (C) wrote:
>>>>>> ? 2022/05/14 17:29, yukuai (C) ??:
>>>>>>> ? 2022/05/05 9:00, yukuai (C) ??:
>>>>>>>> Hi, Paolo
>>>>>>>>
>>>>>>>> Can you take a look at this patchset? It has been quite a long time
>>>>>>>> since we spotted this problem...
>>>>>>>>
>>>>>>>
>>>>>>> friendly ping ...
>>>>>> friendly ping ...
>>>>>
>>>>> I can't speak for Paolo, but I've mentioned before that the majority
>>>>> of your messages end up in my spam. That's still the case, in fact
>>>>> I just marked maybe 10 of them as not spam.
>>>>>
>>>>> You really need to get this issued sorted out, or you will continue
>>>>> to have patches ignore because folks may simply not see them.
>>>>>
>>>> Hi,
>>>>
>>>> Thanks for your notice.
>>>>
>>>> Is it just me or do you see someone else's messages from *huawei.com
>>>> end up in spam? I tried to seek help from our IT support, however, they
>>>> didn't find anything unusual...
>>>
>>> So actually I have noticed that a lot of (valid) email from huawei.com =
(not
>>> just you) ends up in the spam mailbox. For me direct messages usually p=
ass
>>> (likely matching SPF records for originating mail server save the email
>>> from going to spam) but messages going through mailing lists are flagge=
d as
>>> spam because the emails are missing valid DKIM signature but huawei.com
>>> DMARC config says there should be DKIM signature (even direct messages =
are
>>> missing DKIM so this does not seem as a mailing list configuration issu=
e).
>>> So this seems as some misconfiguration of the mails on huawei.com side
>>> (likely missing DKIM signing of outgoing email).
>>
>> SPF/DKIM was indeed a problem earlier for yukaui patches, but I don't
>> see that anymore. Maybe it's still an issue for some emails, from them
>> or Huawei in general?
>=20
> Hum, for me all emails from Huawei I've received even today fail the DKIM
> check. After some more digging there is interesting inconsistency in DMARC
> configuration for huawei.com domain. There is DMARC record for huawei.com
> like:
>=20
> huawei.com.		600	IN	TXT	"v=3DDMARC1;p=3Dnone;rua=3Dmailto:dmarc-8cQ/FyLJE=
fGM2ScGVVA7yQ@public.gmane.org"
>=20
> which means no DKIM is required but _dmarc.huawei.com has:
>=20
> _dmarc.huawei.com.	600	IN	TXT	"v=3DDMARC1;p=3Dquarantine;ruf=3Dmailto:dma=
rc-hv44wF8Li93QT0dZR+AlfA@public.gmane.org;rua=3Dmailto:dmarc-hv44wF8Li93QT=
0dZR+AlfA@public.gmane.org"
>=20
> which says that DKIM is required. I guess this inconsistency may be the
> reason why there are problems with DKIM validation for senders from
> huawei.com. Yu Kuai, can you perhaps take this to your IT support to fix
> this? Either make sure huawei.com emails get properly signed with DKIM or
> remove the 'quarantine' record from _dmarc.huawei.com. Thanks!
>=20
> 								Honza
>=20
Hi, Jan and Jens

I just got response from our IT support:

'fo' is not set in our dmarc configuration(default is 0), which means
SPF and DKIM verify both failed so that emails will end up in spam.

It right that DKIM verify is failed because there is no signed key,
however, our IT support are curious how SPF verify faild.

Can you guys please take a look at ip address of sender? So our IT
support can take a look if they miss it from SPF records.

Thanks,
Kuai
