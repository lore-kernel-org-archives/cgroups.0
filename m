From: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH memcg v6] net: set proper memcg for net_init hooks
 allocations
Date: Mon, 6 Jun 2022 21:45:50 +0300
Message-ID: <360a2672-65a7-4ad4-c8b8-cc4c1f0c02cd@openvz.org>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <Yp4F6n2Ie32re7Ed@qian>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvz-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YkCyZwQdYZTEEFPTy/Pdu0PQJcmELT6TknKthn7ttDg=;
        b=deix4g5mlMz7MedyxE6BvRxtcx1qmV7hufSdLPima/2dHFwtRnvmns59Vp6gEAkztF
         90b2gCLoUi5EVPk6nXdr6ediy095+6ZfsuLjNPu5qRsd7QOZTecIdy59UABjymdHhFd3
         CukWdELH4OvdCFhuTVVy9+PmqESzOBgHOUopOMe+C8iuPNajSYon0HtA76QY/u2l6PH5
         SD0w4cILSzdVngDPpmKM0214udBMV+byCbRyCfOT1sh7G5ATPMpUcDTTRwB51H66TnWl
         RS2dIGgQtmQ63/fssQV7UvuMBjcEuR6b1ehBFkFFiZ4fhPvgQdIc6/NiAg67Uo7+x/Sa
         OJsQ==
Content-Language: en-US
In-Reply-To: <Yp4F6n2Ie32re7Ed@qian>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Qian Cai <quic_qiancai-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/6/22 16:49, Qian Cai wrote:
> On Fri, Jun 03, 2022 at 07:19:43AM +0300, Vasily Averin wrote:

> This triggers a few boot warnings like those.
> 
>  virt_to_phys used for non-linear address: ffffd8efe2d2fe00 (init_net)
>  WARNING: CPU: 87 PID: 3170 at arch/arm64/mm/physaddr.c:12 __virt_to_phys
...
>  Call trace:
>   __virt_to_phys
>   mem_cgroup_from_obj
>   __register_pernet_operations

@@ -1143,7 +1144,13 @@ static int __register_pernet_operations(struct list_head *list,
  		 * setup_net() and cleanup_net() are not possible.
		 */
		for_each_net(net) {
+			struct mem_cgroup *old, *memcg;
+
+			memcg = mem_cgroup_or_root(get_mem_cgroup_from_obj(net));   <<<<  Here
+			old = set_active_memcg(memcg);
 			error = ops_init(ops, net);
+			set_active_memcg(old);
+			mem_cgroup_put(memcg);
...
+static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
+{
+	struct mem_cgroup *memcg;
+
+	rcu_read_lock();
+	do {
+		memcg = mem_cgroup_from_obj(p); <<<<
+	} while (memcg && !css_tryget(&memcg->css));
...
struct mem_cgroup *mem_cgroup_from_obj(void *p)
{
        struct folio *folio;

        if (mem_cgroup_disabled())
                return NULL;

        folio = virt_to_folio(p); <<<< here
...
static inline struct folio *virt_to_folio(const void *x)
{
        struct page *page = virt_to_page(x); <<< here

... (arm64)
#define virt_to_page(x)         pfn_to_page(virt_to_pfn(x))  
...
#define virt_to_pfn(x)          __phys_to_pfn(__virt_to_phys((unsigned long)(x)))
...
phys_addr_t __virt_to_phys(unsigned long x)
{
        WARN(!__is_lm_address(__tag_reset(x)),
             "virt_to_phys used for non-linear address: %pK (%pS)\n",

from arch/x86/include/asm/page.h:
 * virt_to_page(kaddr) returns a valid pointer if and only if
 * virt_addr_valid(kaddr) returns true.

As far as I understand this report means that 'init_net' have incorrect
virtual address on arm64.

Roman, Shakeel, I need your help

Should we perhaps verify kaddr via virt_addr_valid() before using virt_to_page()
If so, where it should be checked?

Thank you,
	Vasily Averin
