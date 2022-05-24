From: Yu Kuai <yukuai3@huawei.com>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Tue, 24 May 2022 09:13:40 +0800
Message-ID: <13ad158e-7859-ca61-209e-7d1fe99d0bdb@huawei.com>
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
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20220523152516.7sr247i3bzwhr44w@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jan Kara <jack@suse.cz>
Cc: paolo.valente@linaro.org, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, Jens Axboe <axboe@kernel.dk>

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
> huawei.com.		600	IN	TXT	"v=3DDMARC1;p=3Dnone;rua=3Dmailto:dmarc@edm.huawe=
i.com"
>=20
> which means no DKIM is required but _dmarc.huawei.com has:
>=20
> _dmarc.huawei.com.	600	IN	TXT	"v=3DDMARC1;p=3Dquarantine;ruf=3Dmailto:dma=
rc@huawei.com;rua=3Dmailto:dmarc@huawei.com"
>=20
> which says that DKIM is required. I guess this inconsistency may be the
> reason why there are problems with DKIM validation for senders from
> huawei.com. Yu Kuai, can you perhaps take this to your IT support to fix
> this? Either make sure huawei.com emails get properly signed with DKIM or
> remove the 'quarantine' record from _dmarc.huawei.com. Thanks!
Of course, I'll try to contact our IT support.

Thanks,
Kuai
>=20
> 								Honza
>=20
