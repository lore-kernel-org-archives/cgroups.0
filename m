From: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [QUESTION] Cgroup namespace and cgroup v2
Date: Mon, 2 Nov 2020 09:09:43 -0700
Message-ID: <5be94abd-1663-55e1-01a7-f36405fb0669@oracle.com>
References: <d223c6ba-9fcf-8728-214b-1bce30f26441@oracle.com>
 <20201027182659.GA62134@blackbook>
 <001e7b1d-1b7c-e3d8-493f-2b78b3b093b1@oracle.com>
 <20201102140921.GA4691@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=s5s8+s0XNuoA1n0Xmu2wW9hwDujD3Ki9LMC4+zTMlxw=;
 b=vo45Yog4xFjVF97suIFIOjVQk5cZk0X8MaoKBEWEHzNfiMxnPXMQUJifG10U9l9zhzR6
 LB25nqeRBJiRdKCfaok+WUauYGyyHBrqQqa6gL/xdGCirAobM3+lmoW0b2e/A3j5YRFl
 xCzOWW3WKTqvUSflsW7FOxkAt/Vp8gSG4/7TVMnAUfWe3Zpl93gp5/S+jgai8XR9cLva
 zDuJ01YX7Zi4aAUnPA6uwMuRMxKeB1LfMPrhsCNJE/HBDx+50OsSYChSvOjMOhnxctWZ
 2n9iwVU5p8lPIlEBt4bfc32jLJIs+jgReYHj3g7stsXOkNOMYwIz0Aqe1Yr7R+fpGy/N RA== 
In-Reply-To: <20201102140921.GA4691@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 11/2/20 7:09 AM, Michal Koutn=FD wrote:
> On Fri, Oct 30, 2020 at 07:11:20AM -0600, Tom Hromatka <tom.hromatka-QHcL=
ZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> Would you mind sharing some of the other discrepancies?=A0 I
>> would like to be prepared when we run into them as well.
> Search for CFTYPE_NOT_ON_ROOT flag (that was on my mind above). It
> causes a visible difference between host and container (OTOH, you won't
> be able to write into such files typically, so that's effectively equal
> to the host).

Awesome!=A0 Thanks.

Tom

>
> Michal
>

