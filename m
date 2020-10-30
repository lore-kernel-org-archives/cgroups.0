From: Tom Hromatka <tom.hromatka-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [QUESTION] Cgroup namespace and cgroup v2
Date: Fri, 30 Oct 2020 07:11:20 -0600
Message-ID: <001e7b1d-1b7c-e3d8-493f-2b78b3b093b1@oracle.com>
References: <d223c6ba-9fcf-8728-214b-1bce30f26441@oracle.com>
 <20201027182659.GA62134@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=P4mtStT2D2qnh4vVbPD791lmQ3o57FSAUHJXBvfRArk=;
 b=tdQ33e24t9bxSOVk27NNg8uJUHv0y2qs10GHQLEWt8+YFsE/EDrJ+GqzOcYh/SC7EA5p
 UldB+zXykFrU/rrTe7RkWO6UCqtmA1LbyyRAEOLG93RKlhrJfm4fHZ4YM4NYM0IKDLZZ
 pTH/tM4mpRtCtWsoy+wS9w0hhihOHacfQGQTSnTrzH7iMtiFXq4jnPT/2/7ovBGsJuTu
 W2n39wO1ecOOwq92pOqWqmPlTbAbK1DNxrL8UAIt0h+61UG1Y6GGJQ2K5/rf9MYF9tpR
 4ASde0iGGosNaYdfJSDdSSiV6ybWybe4l9J3iabvlSLRjO5Bea07tAdAuCv+QjSIjumx +w== 
In-Reply-To: <20201027182659.GA62134@blackbook>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/27/20 12:26 PM, Michal Koutn=FD wrote:
> Hi Tom.
>
> On Tue, Oct 20, 2020 at 03:12:28PM -0600, Tom Hromatka <tom.hromatka-QHcL=
ZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
>> But this fails on a cgroup v2 system in a
>> cgroup namespace because the root cgroup is a non-leaf cgroup.
> Yes, the no internal process constraint simplifies and enables many
> things for v2 controllers.
>
>> * As outlined above, the behavior of the "root" cgroup in a cgroup
>>  =A0 namespace on a v2 system differs from the behavior of the
>>  =A0 unnamespaced root cgroup.=A0 At best this is inconsistent; at worst,
>>  =A0 this may leak information to an unethical program.
> What information does this leak? (That it's running in a cgroup namespace=
?)
> Note that this isn't the only discrepancy between host root cgroup and
> namespaced root cgroup. The host group is simply special.

Oops.=A0 My wording was overly dramatic.=A0 My in-house customers
get nervous when things differ within a container vs. on a host.

You're right, it differs, but that's an acceptable side effect
of the improved design of cgroup v2.

Would you mind sharing some of the other discrepancies?=A0 I
would like to be prepared when we run into them as well.

Thanks!

>
>>  =A0 Any ideas how =A0 we can make the behavior more consistent for the
>> user and =A0 libcgroup?
> You can disable the controllers (via parent's cgroup.subtree_control) to
> allow migration into the parent. Of course that affects also siblings of
> the removed cgroup.

Good call.=A0 I didn't think of that.

>
>> * I will likely add a flag to cgdelete to simply kill processes in
>>  =A0 a cgroup rather than try and move them to the parent cgroup.
>>  =A0 Moving processes to the parent cgroup is somewhat challenging
>>  =A0 even in a cgroup v1 system due to permissions, etc.
> In general, migrations with controlled v2 cgroup are not supported, so
> moving processes up and (especially) down has less sense than in v1.
> Hence, refusing the delete operation on a populated cgroup (with
> controllers) is IMO justified.

That makes a lot of sense.=A0 I think I will need to spend
time with the database team and others.=A0 Cgroup v2 is simply
different enough that we'll need to rethink some of the
decisions that were made for cgroup v1.

Thanks so much for the help.

Tom

>
>
> Michal

