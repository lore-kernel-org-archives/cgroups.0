From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Tue, 11 Jul 2023 10:58:48 +0800
Message-ID: <7d3323ab-f796-6846-ab08-5d48734595e1@huawei.com>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
 <ue4duahv6scnn64zgduuhiyq2gh33w7x5ftdffw3uqcn4ahyd2@txxtxf2fkzp2>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ue4duahv6scnn64zgduuhiyq2gh33w7x5ftdffw3uqcn4ahyd2@txxtxf2fkzp2>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/10 23:46, Michal Koutn=FD wrote:
> Hi.
>=20
> On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin <linmiaohe-hv44wF8Li=
93QT0dZR+AlfA@public.gmane.org> wrote:
>> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
>> it to simplify the code. No functional change intended.
>=20
> I'd add a comment that it builds upon cgroup_addrm_files()'s:

Do you mean something like below:

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b0d98542eea2..2c02f319a7d4 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4320,6 +4320,7 @@ static int cgroup_init_cftypes(struct cgroup_subsys *=
ss, struct cftype *cfts)
        return ret;
 }

+/* It builds upon cgroup_addrm_files()'s. */
 static void cgroup_rm_cftypes_locked(struct cftype *cfts)
 {
        lockdep_assert_held(&cgroup_mutex);


>> For removals, this function never fails.
>=20
>> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane=
.org>
>> ---
>>  kernel/cgroup/cgroup.c | 9 +++------
>>  1 file changed, 3 insertions(+), 6 deletions(-)
>=20
> Reviewed-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>

Thanks for review and suggestion.

