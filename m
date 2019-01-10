From: William Kucharski <william.kucharski@oracle.com>
Subject: Re: [PATCH] mm: memcontrol: use struct_size() in kmalloc()
Date: Thu, 10 Jan 2019 05:12:17 -0700
Message-ID: <8B12C965-1406-4464-96FF-B9C04187DD7D@oracle.com>
References: <20190104183726.GA6374@embeddedor>
Mime-Version: 1.0 (Mac OS X Mail 12.2 \(3445.102.3\))
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=content-type :
 mime-version : subject : from : in-reply-to : date : cc :
 content-transfer-encoding : message-id : references : to;
 s=corp-2018-07-02; bh=f8thXKqGmXAcAg92JOqwvN4UTlK63hLPBTTcunmF/Yk=;
 b=VpiCVzuUhmx7SBCUVoFZ7XNr/F1TepG0jas0tBYO4wSywiG0VKuqrHQGbXF4ATcbOOam
 ENiwcr49XCkeHXiGdWUu+wjNwXk9fcptxpLVhw1AvMfhNqa4pBSUFPEUyrAEJ/q6jVrK
 3jtcO3Cv8weW8SAISSfzhNv/qtUmNlL0v+3OOa3n64J7ane0n8R7UxALUtEH0DAmegUs
 +IHDZaJxTUezbPiQvxjRDd2fWwz9AFPLv0lnfPlyljnqxW5JaanH5HRnigY0ZoTxZx+D
 q1PWOxrLjNmk8kh23VkshejivJk9FOJP6+gOj+B/oAm1rFCLzEZ/wyFxEJlmgYJ2D1PJ bw== 
In-Reply-To: <20190104183726.GA6374@embeddedor>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Jan 4, 2019, at 11:37 AM, Gustavo A. R. Silva =
<gustavo@embeddedor.com> wrote:
>=20
> One of the more common cases of allocation size calculations is =
finding
> the size of a structure that has a zero-sized array at the end, along
> with memory for some number of elements for that array. For example:
>=20
> struct foo {
>    int stuff;
>    void *entry[];
> };
>=20
> instance =3D kmalloc(sizeof(struct foo) + sizeof(void *) * count, =
GFP_KERNEL);
>=20
> Instead of leaving these open-coded and prone to type mistakes, we can
> now use the new struct_size() helper:
>=20
> instance =3D kmalloc(struct_size(instance, entry, count), GFP_KERNEL);
>=20
> This code was detected with the help of Coccinelle.
>=20
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
> mm/memcontrol.c | 3 +--
> 1 file changed, 1 insertion(+), 2 deletions(-)
>=20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index af7f18b32389..ad256cf7da47 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3626,8 +3626,7 @@ static int =
__mem_cgroup_usage_register_event(struct mem_cgroup *memcg,
> 	size =3D thresholds->primary ? thresholds->primary->size + 1 : =
1;
>=20
> 	/* Allocate memory for new array of thresholds */
> -	new =3D kmalloc(sizeof(*new) + size * sizeof(struct =
mem_cgroup_threshold),
> -			GFP_KERNEL);
> +	new =3D kmalloc(struct_size(new, entries, size), GFP_KERNEL);
> 	if (!new) {
> 		ret =3D -ENOMEM;
> 		goto unlock;
> --=20
> 2.20.1
>=20

Reviewed-by: William Kucharski <william.kucharski@oracle.com>=
