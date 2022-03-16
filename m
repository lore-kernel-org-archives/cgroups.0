From: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Subject: RE: [EXTERNAL] Re: Split process across multiple schedulers?
Date: Wed, 16 Mar 2022 08:17:04 +0000
Message-ID: <77e72fcbbff94977a5179446265c18d2@saabgroup.com>
References: <b5039be462e8492085b6638df2a761ca@saabgroup.com>
 <20220314164332.GA20424@blackbody.suse.cz>
 <bf2ea0888a9e45d3aafe412f0094cf86@saabgroup.com>
 <20220315103553.GA3780@blackbody.suse.cz>
 <84e5b8652edd47d29597d499f29753d6@saabgroup.com>
 <20220315173329.GB3780@blackbody.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Filter: OpenDKIM Filter v2.11.0 weald.air.saab.se 22G8H7g0007954
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=saabgroup.com;
        s=weald; t=1647418627;
        bh=nS2kp8sjDDEi2HeJUbR6OjAh6tLLzGTSTiLmbumiWbM=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=js5nsw9AEIXY6vsi4cYtXY6dvrKF8Aa0qdixEbfhtEHSd3E1EDv7wzFi6lGGfZ4LP
         Aod4UpRRBFrG2qkQ03UUHGYlhNNIx0fHngXoNayK4pJ6eHWSr6FTUya81XCRtl5Dfl
         O4fBP0he8zmwjY/2jUbeB8UhHgDoUyEDN9HzURwg=
In-Reply-To: <20220315173329.GB3780-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
To: =?iso-8859-1?Q?Michal_Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> I think you've complete info now how threads are handled with cgroups.

Thank you for your excellent support! :D


> Good luck with the fork :-)

It's basically already done as part of a Master Thesis. Now we'll
experiment with it and see how theory clashes with the real world. :)


/John

-----Original Message-----
From: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>=20
Sent: den 15 mars 2022 18:34
To: Olsson John <john.olsson-zlDGZTLOEuz3oGB3hsPCZA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [EXTERNAL] Re: Split process across multiple schedulers?

On Tue, Mar 15, 2022 at 03:49:52PM +0000, Olsson John <john.olsson@saabgrou=
p.com> wrote:
> As you might have already surmised it was a placeholder example to=20
> give the general idea. I think it is time to add some more details. :)

Thanks for sharing the additional description.

> Assume that you have an embedded system running some kind of software=20
> with real time like properties. You want to develop and debug your=20
> software locally on your high-end machine since it is much more=20
> convenient. Alas the software runs way too fast due to the difference=20
> in performance so you can't detect overruns etc.

There are certainly more knowledgeable people than me to help with debuggin=
g such environments.

> One way of implementing this kind of scheduler would be to create a=20
> fork of the FIFO scheduler that have this behavior.

I think you've complete info now how threads are handled with cgroups.

Good luck with the fork :-)


Michal
