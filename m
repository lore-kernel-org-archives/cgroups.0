From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroup: add network limits subsystem
Date: Mon, 24 Aug 2015 21:50:18 +0530
Message-ID: <CAG53R5WMgZ6b5D1R7uK7=RDV+nYkAjtA=adLdaHj9bqJ3Vnmew@mail.gmail.com>
References: <CAAN1KCEKLj1YM37QO7xKCq1K7vTqWMKKL+T+W2n1hOo1rAbM9g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=usT3tBaJbw/i94ALBZ+7cOn5ktzjxGadZg6j1gBO6Ns=;
        b=JskqfnZFDUT2upuoxncaJFFCLj17ZJeg8xYNv8OXPQVbM7tlpHd7doduuMvvQPA05V
         5SwaxSF5s2l0OB956XBaQ3/aArDKb4qnHTXWFSgP2GNl+VBrNXrB7hu+c33evhL7UYEh
         HFkTTnID6Y4hZ4LIhSIB9AotC3btW4A/V+LkXRqdnYWoHmFB4FBZkYNqnf8CgHn3zdwH
         ZY2RNDR8JSr4JJYeQjul6YpapBsWv5iZI/zrj3dR0AF7Dmqs0crAH0OHEp1Yo//A0Zbr
         wvXWuAa9id0heZ0+8VAsLuE3s/T6V+DN7dZRJnK+7drdQhEnZwpE1xcty2irTklYXSg/
         RxvQ==
In-Reply-To: <CAAN1KCEKLj1YM37QO7xKCq1K7vTqWMKKL+T+W2n1hOo1rAbM9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Kurbatov <dk-PUtEO5/C7cqHXe+LvDLADg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 24, 2015 at 5:36 PM, Dmitry Kurbatov <dk-PUtEO5/C7cqHXe+LvDLADg@public.gmane.org> wrote:
> Hi All.
>
> I've posted this message to LKML but have no answer. It's a second try.
>
> I've written a new cgroup subsystem named network resource
> limits(net_lim). It allows to limit a few network resources like
> binding ipv4 ports and binding ipv4 addresses. Also it allows to
> redefine ephemeral ports range and define default ipv4 address for
> binding when INADDR_ANY(0.0.0.0) is used. For a specific control
> group, of course.
>
> These new capabilities can be used for shared hosting, when you can't
> use network namespaces because of high network load and NAT overhead.

If I am not wrong, network namespaces allows you to avoid doing NAT
because of the primary nature of isolation of network via namespace.
Every single network namespace will have exactly same IP addresses and
port numbers.

I haven't looked at the code or have nor have performance results
ready lately but there should not be performance impact either on the
tx or rx path as every interface belongs to exactly one network
namespce which avoid lookup or reverse lookup which are usually
costly.

Do you mean underlying hardware support is not present for isolated L2
layer due to which network namespace might bring overhead?

> This patch provides a lightweight approach that allows to share one
> ports/address space to many users or containers and account traffic
> via tc or iptables using user's port ranges in rules. net_lim allows
> to avoid creating network namespace and additional interface in it,
> adding one more ip address and setting up routing for this purposes.
>
> Let's demonstrate an example of using this subsystem:
>
> For example, we need to limit binding ports/address for a specific
> user and set him new ephemeral port range for outgoing connections and
> bindings to zero port:
>
> 1. Set new common ports range(2000-2100 + 30000) and ephemeral ports
> range(60000-61000):
>
> echo "2000-2100,30000,60000-61000" > net_lim.ipv4.ports
> Here we limit binding to common and ephemeral ports. When program will
> try to bind to port in listed ports/range it will succeed, or gain
> EACCESS otherwise.
>
> Please note that the latest ports range will be provided for ephemeral
> ports range (60000-61000). This port range also allowed for binding
> for this control group via direct bind() and via bind to zero port.
>
> Also you can read new ephemeral ports range via specigic parameter:
>
> cat net_lim.ipv4.ip_locat_port_range
> 60000-61000
>
> 2. Set list of ip addresses allowed for binding:
>
> echo "1.1.1.1,2.2.2.2,127.0.0.1" > net_lim.ipv4.addrs
> Here we limit binding to set of addresses 1.1.1.1,2.2.2.2 and
> 127.0.0.1. When program in this control group will bind to one of this
> address, it will be ok, or gain EACCESS otherwise.
>
> Please note that the first ip address (1.1.1.1) will be used as
> default address - it will be substituted instead of
> INADDR_ANY(0.0.0.0) while bind().
>
> Also you can read current default address value via specific parameter:
>
> cat net_lim.ipv4.default_address
> 1.1.1.1
>
> That's all, folks (c)
>
> But there is a few notes:
>
> 1. By-default all net_lim values are empty. This means that no limits
> will be applied to control group (i.e. default system behavior).
> 2. You can limit ports in range 1-65535. Port 0 (zero) can't be forbidden.
>
> Now, I have a few questions to you:
>
> 1. Shoud I add checking limits in parent control group (hierarchical checking)?
> 2. Whether net_lim is necessary in the kernel? ;)
>
>
> ========= patch below =========
> From: Dmitry Kurbatov <dk-70MgRk2y9vQ@public.gmane.org>
> Date: Thu, 13 Aug 2015 12:07:24 +0300
> Subject: [PATCH] cgroup: add network limits subsystem
>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Dmitry Kurbatov <dk-70MgRk2y9vQ@public.gmane.org>
>
> ---
>  include/linux/cgroup_subsys.h   |   4 +
>  include/linux/net_lim_cgroup.h  |  39 ++++
>  init/Kconfig                    |   5 +
>  kernel/Makefile                 |   1 +
>  kernel/net_lim_cgroup.c         | 501 ++++++++++++++++++++++++++++++++++++++++
>  net/ipv4/af_inet.c              |  19 +-
>  net/ipv4/inet_connection_sock.c |   8 +
>  7 files changed, 576 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/net_lim_cgroup.h
>  create mode 100644 kernel/net_lim_cgroup.c
>
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index e4a96fb..51e7c73 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -47,6 +47,10 @@ SUBSYS(net_prio)
>  SUBSYS(hugetlb)
>  #endif
>
> +#if IS_ENABLED(CONFIG_CGROUP_NET_LIM)
> +SUBSYS(net_lim)
> +#endif
> +
>  /*
>   * The following subsystems are not supported on the default hierarchy.
>   */
> diff --git a/include/linux/net_lim_cgroup.h b/include/linux/net_lim_cgroup.h
> new file mode 100644
> index 0000000..eef999b
> --- /dev/null
> +++ b/include/linux/net_lim_cgroup.h
> @@ -0,0 +1,39 @@
> +#ifndef _NET_LIM_CGROUP_H
> +#define _NET_LIM_CGROUP_H
> +
> +#include <linux/kernel.h>
> +#include <linux/threads.h>
> +#include <linux/atomic.h>
> +#include <linux/cgroup.h>
> +#include <linux/slab.h>
> +#include <linux/in.h>
> +#include <linux/inet.h>
> +#include <linux/rwlock_types.h>
> +
> +struct net_lim_range_item {
> +   unsigned int start, end;
> +   struct list_head list;
> +};
> +
> +struct net_lim_addr_item {
> +   u32 addr;
> +   struct list_head list;
> +};
> +
> +struct net_lim_cgroup {
> +   struct cgroup_subsys_state css;
> +
> +   /* inet_bind() available ports range */
> +   struct list_head port_ranges;
> +
> +   /* inet_bind() available address range */
> +   struct list_head addrs;
> +};
> +
> +struct net_lim_cgroup *css_net_lim(struct cgroup_subsys_state *css);
> +int net_lim_port_allowed(struct task_struct *tsk, unsigned int port);
> +int net_lim_addr_allowed(struct task_struct *tsk, u32 addr);
> +void net_lim_get_local_port_range(struct task_struct *tsk, int *low,
> int *high);
> +u32 net_lim_get_default_address(struct task_struct *tsk);
> +
> +#endif
> diff --git a/init/Kconfig b/init/Kconfig
> index af09b4f..f94a361 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -949,6 +949,11 @@ config CGROUP_DEBUG
>
>       Say N if unsure.
>
> +config CGROUP_NET_LIM
> +   bool "Network limits cgroup subsystem"
> +   help
> +     Provides custom network limits from cgroups
> +
>  config CGROUP_FREEZER
>     bool "Freezer cgroup subsystem"
>     help
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 43c4c92..37a4e30 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -56,6 +56,7 @@ obj-$(CONFIG_COMPAT) += compat.o
>  obj-$(CONFIG_CGROUPS) += cgroup.o
>  obj-$(CONFIG_CGROUP_FREEZER) += cgroup_freezer.o
>  obj-$(CONFIG_CPUSETS) += cpuset.o
> +obj-$(CONFIG_CGROUP_NET_LIM) += net_lim_cgroup.o
>  obj-$(CONFIG_UTS_NS) += utsname.o
>  obj-$(CONFIG_USER_NS) += user_namespace.o
>  obj-$(CONFIG_PID_NS) += pid_namespace.o
> diff --git a/kernel/net_lim_cgroup.c b/kernel/net_lim_cgroup.c
> new file mode 100644
> index 0000000..123cf40
> --- /dev/null
> +++ b/kernel/net_lim_cgroup.c
> @@ -0,0 +1,501 @@
> +#include <linux/kernel.h>
> +#include <linux/threads.h>
> +#include <linux/atomic.h>
> +#include <linux/cgroup.h>
> +#include <linux/slab.h>
> +#include <linux/net_lim_cgroup.h>
> +#include <linux/string.h>
> +
> +#define RANGE_MAX_LEN 12
> +#define IP_ADDRESS_MAX_LEN 16
> +#define NIPQUAD(addr) \
> +    ((unsigned char *)&addr)[0], \
> +    ((unsigned char *)&addr)[1], \
> +    ((unsigned char *)&addr)[2], \
> +    ((unsigned char *)&addr)[3]
> +
> +static DEFINE_RWLOCK(net_lim_croup_rwlock);
> +
> +struct net_lim_cgroup *css_net_lim(struct cgroup_subsys_state *css)
> +{
> +   return container_of(css, struct net_lim_cgroup, css);
> +}
> +
> +/*
> + * Clean list @list_ranges and deallocate all items.
> + */
> +static void net_lim_range_clean(struct list_head *list_ranges)
> +{
> +   struct net_lim_range_item *walk, *tmp;
> +
> +   list_for_each_entry_safe(walk, tmp, list_ranges, list) {
> +       list_del(&walk->list);
> +       kfree(walk);
> +   }
> +}
> +
> +/*
> + * Clean list @list_addrs and deallocate all items.
> + */
> +static void net_lim_addrs_clean(struct list_head *list_addrs)
> +{
> +   struct net_lim_addr_item *walk, *tmp;
> +
> +   list_for_each_entry_safe(walk, tmp, list_addrs, list) {
> +       list_del(&walk->list);
> +       kfree(walk);
> +   }
> +}
> +
> +/*
> + * Allocate new net_lim subsystem node.
> + */
> +static struct cgroup_subsys_state *
> +net_lim_css_alloc(struct cgroup_subsys_state *parent)
> +{
> +   struct net_lim_cgroup *net_lim;
> +
> +   net_lim = kzalloc(sizeof(struct net_lim_cgroup), GFP_KERNEL);
> +   if (!net_lim)
> +       return ERR_PTR(-ENOMEM);
> +
> +   /* initialize ports ranges. */
> +   INIT_LIST_HEAD(&net_lim->port_ranges);
> +
> +   /* initialize addrs ranges. */
> +   INIT_LIST_HEAD(&net_lim->addrs);
> +
> +   return &net_lim->css;
> +}
> +
> +/*
> + * Deallocate memory of items in net_lim lists.
> + */
> +static void net_lim_ranges_clean(struct net_lim_cgroup *net_lim)
> +{
> +   net_lim_range_clean(&net_lim->port_ranges);
> +   net_lim_addrs_clean(&net_lim->addrs);
> +}
> +
> +/*
> + * Free net_lim node.
> + */
> +static void net_lim_css_free(struct cgroup_subsys_state *css)
> +{
> +   struct net_lim_cgroup *net_lim = css_net_lim(css);
> +
> +   net_lim_ranges_clean(net_lim);
> +   kfree(net_lim);
> +}
> +
> +/*
> + * Validate and extract port range string.
> + */
> +static int extract_port_range(char *str, unsigned int *start,
> unsigned int *end)
> +{
> +   char *tmp = str;
> +
> +   if (strlen(str) > RANGE_MAX_LEN-1)
> +       return -ERANGE;
> +
> +   if (strchr(tmp, '-') == NULL) {
> +       if (kstrtoint(str, 0, (int *)start))
> +           return -EINVAL;
> +       *end = *start;
> +   } else {
> +       tmp = strsep(&str, "-");
> +
> +       if ((*tmp == '\0') ||
> +                       (str == NULL) ||
> +                       (*str == '\0'))
> +           return -EINVAL;
> +
> +       if (kstrtoint(tmp, 0, (int *)start))
> +           return -EINVAL;
> +       if (kstrtoint(str, 0, (int *)end))
> +           return -EINVAL;
> +   }
> +
> +   if ((*end < *start) ||
> +                   (*start < 1) ||
> +                   (*start > 65535) ||
> +                   (*end < 1) ||
> +                   (*end > 65535))
> +       return -ERANGE;
> +
> +   return 0;
> +}
> +
> +/*
> +* Validate and extract ip address from string.
> +*/
> +int extract_address(char *str, u32 *addr)
> +{
> +   const char *end;
> +
> +   if (strlen(str) > IP_ADDRESS_MAX_LEN-1)
> +       return -EINVAL;
> +
> +   if (in4_pton(str, -1, (u8 *)addr, -1, &end) && !*end)
> +       return 0;
> +
> +   return -EINVAL;
> +}
> +
> +/*
> +* Aloccate memory and add low-high range to list.
> +*/
> +static int list_add_range(struct list_head *list_ranges, unsigned int low,
> +                                       unsigned int high)
> +{
> +   struct net_lim_range_item *range;
> +
> +   range = kmalloc(sizeof(*range), GFP_KERNEL);
> +   if (!range)
> +       return -ENOMEM;
> +
> +   range->start = low;
> +   range->end = high;
> +   list_add_tail(&range->list, list_ranges);
> +   return 0;
> +}
> +
> +/*
> +* Aloccate memory and add address to list.
> +*/
> +static int list_add_address(struct list_head *list_addrs, u32 addr)
> +{
> +   struct net_lim_addr_item *addr_item;
> +
> +   addr_item = kmalloc(sizeof(*addr_item), GFP_KERNEL);
> +   if (!addr_item)
> +       return -ENOMEM;
> +
> +   addr_item->addr = addr;
> +   list_add_tail(&addr_item->list, list_addrs);
> +   return 0;
> +}
> +
> +/*
> +* Parse string of ports and ranges.
> +*/
> +static int parse_ports_list(char *buf, struct list_head *list_ranges)
> +{
> +   char *str;
> +   u32 low, high;
> +   int ret = 0;
> +
> +   while ((str = strsep(&buf, ","))) {
> +       /* Extract port or region. */
> +       if ((ret = extract_port_range(str, &low, &high)))
> +           return ret;
> +
> +       if ((ret = list_add_range(list_ranges, low, high)))
> +           return ret;
> +   }
> +
> +   return ret;
> +}
> +
> +/*
> +* Parse string of addrs.
> +*/
> +static int parse_addrs_list(char *buf, struct list_head *list_addrs)
> +{
> +   char *str;
> +   u32 addr;
> +   int ret = 0;
> +   while ((str = strsep(&buf, ","))) {
> +       /* Extract ip address from @str. */
> +       if ((ret = extract_address(str, &addr)))
> +           return ret;
> +
> +       if ((ret = list_add_address(list_addrs, addr)))
> +           return ret;
> +   }
> +   return ret;
> +}
> +
> +/*
> +* Write list of allowed ports.
> +*/
> +static ssize_t net_lim_cgroup_ports_write(struct kernfs_open_file *of,
> +                                       char *buf, size_t nbytes, loff_t off)
> +{
> +   int retval = 0;
> +   char *buffer = strstrip(buf);
> +   struct net_lim_cgroup *net_lim = css_net_lim(of_css(of));
> +   LIST_HEAD(list_ranges);
> +
> +   if (css_has_online_children(&net_lim->css))
> +       return -EINVAL;
> +
> +   /* Don't apply cgroup port values. */
> +   if (*buffer == '\0') {
> +       net_lim_range_clean(&net_lim->port_ranges);
> +       return nbytes;
> +   }
> +
> +   if ((retval = parse_ports_list(buffer, &list_ranges))) {
> +       net_lim_range_clean(&list_ranges);
> +       return retval;
> +   }
> +
> +   /* Here we have valid list of port ranges. Clear existed list and
> +   * replace with new one. */
> +   write_lock(&net_lim_croup_rwlock);
> +   net_lim_range_clean(&net_lim->port_ranges);
> +   list_splice(&list_ranges, &net_lim->port_ranges);
> +   write_unlock(&net_lim_croup_rwlock);
> +   return nbytes;
> +}
> +
> +/*
> +* Show list of allowed ports.
> +*/
> +static int net_lim_cgroup_ports_seq_show(struct seq_file *seq, void *v)
> +{
> +   struct net_lim_range_item *walk;
> +   struct cgroup_subsys_state *css = seq_css(seq);
> +   struct net_lim_cgroup *net_lim = css_net_lim(css);
> +   int comma = 0;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   list_for_each_entry(walk, &net_lim->port_ranges, list) {
> +       if (comma++)
> +           seq_printf(seq, ",");
> +       if (walk->start == walk->end) {
> +           seq_printf(seq, "%d", walk->start);
> +       } else {
> +           seq_printf(seq, "%d-%d", walk->start, walk->end);
> +       }
> +   }
> +   read_unlock(&net_lim_croup_rwlock);
> +   if (comma)
> +       seq_printf(seq, "\n");
> +   return 0;
> +}
> +
> +/*
> +* Show current local_port_range value.
> +*/
> +static int net_lim_cgroup_local_port_range_seq_show(struct seq_file *seq,
> +                                                               void *v)
> +{
> +   struct net_lim_cgroup *net_lim = css_net_lim(seq_css(seq));
> +   struct net_lim_range_item *range;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   if (list_empty(&net_lim->port_ranges))
> +       goto _unlock;
> +
> +   range = list_last_entry(&net_lim->port_ranges,
> +                           struct net_lim_range_item, list);
> +
> +   seq_printf(seq, "%d-%d\n", range->start, range->end);
> +
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +   return 0;
> +}
> +
> +/*
> +* Write list of allowed addrs.
> +*/
> +static ssize_t net_lim_cgroup_addrs_write(struct kernfs_open_file *of,
> +                                       char *buf, size_t nbytes, loff_t off)
> +{
> +   int retval = 0;
> +   char *buffer = strstrip(buf);
> +   struct net_lim_cgroup *net_lim = css_net_lim(of_css(of));
> +   LIST_HEAD(list_addrs);
> +
> +   if (css_has_online_children(&net_lim->css))
> +       return -EINVAL;
> +
> +   /* Don't apply cgroup values to limit bind() addresses. */
> +   if (*buffer == '\0') {
> +       net_lim_addrs_clean(&net_lim->addrs);
> +       // net_lim_list_clean(&net_lim->addrs, walk, tmp);
> +       return nbytes;
> +   }
> +
> +   if ((retval = parse_addrs_list(buffer, &list_addrs))) {
> +       net_lim_addrs_clean(&list_addrs);
> +       return retval;
> +   }
> +
> +   /* Here we have valid list of addrs. Clear existed list and
> +   * replace with new one. */
> +   write_lock(&net_lim_croup_rwlock);
> +   net_lim_addrs_clean(&net_lim->addrs);
> +   list_splice(&list_addrs, &net_lim->addrs);
> +   write_unlock(&net_lim_croup_rwlock);
> +   return nbytes;
> +}
> +
> +/*
> +* Show list of allowed addrs.
> +*/
> +static int net_lim_cgroup_addrs_seq_show(struct seq_file *seq, void *v)
> +{
> +   struct net_lim_addr_item *walk;
> +   struct net_lim_cgroup *net_lim = css_net_lim(seq_css(seq));
> +   int wrote = 0;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   list_for_each_entry(walk, &net_lim->addrs, list) {
> +       if (wrote++)
> +           seq_printf(seq, ",");
> +       seq_printf(seq, "%d.%d.%d.%d", NIPQUAD(walk->addr));
> +   }
> +   if (wrote)
> +       seq_printf(seq, "\n");
> +   read_unlock(&net_lim_croup_rwlock);
> +   return 0;
> +}
> +
> +/*
> +* Show current default_address value.
> +*/
> +static int net_lim_cgroup_default_address_seq_show(struct seq_file *seq,
> +                                                               void *v)
> +{
> +   struct net_lim_cgroup *net_lim = css_net_lim(seq_css(seq));
> +   struct net_lim_addr_item *addr_item = NULL;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   if (list_empty(&net_lim->addrs))
> +       goto _unlock;
> +
> +   addr_item = list_first_entry(&net_lim->addrs, struct
> net_lim_addr_item, list);
> +   seq_printf(seq, "%d.%d.%d.%d\n", NIPQUAD(addr_item->addr));
> +
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +   return 0;
> +}
> +
> +
> +static struct cftype net_lim_files[] = {
> +   {
> +       .name = "ipv4.ports",
> +       .write = net_lim_cgroup_ports_write,
> +       .seq_show = net_lim_cgroup_ports_seq_show,
> +   },
> +   {
> +       .name = "ipv4.ip_local_port_range",
> +       .seq_show = net_lim_cgroup_local_port_range_seq_show,
> +   },
> +   {
> +       .name = "ipv4.addrs",
> +       .write = net_lim_cgroup_addrs_write,
> +       .seq_show = net_lim_cgroup_addrs_seq_show,
> +   },
> +   {
> +       .name = "ipv4.default_address",
> +       .seq_show = net_lim_cgroup_default_address_seq_show,
> +   },
> +   { } /* terminate */
> +};
> +
> +struct cgroup_subsys net_lim_cgrp_subsys = {
> +   .css_alloc  = net_lim_css_alloc,
> +   .css_free   = net_lim_css_free,
> +   .legacy_cftypes = net_lim_files,
> +   .dfl_cftypes    = net_lim_files,
> +};
> +
> +int net_lim_port_allowed(struct task_struct *tsk, unsigned int port)
> +{
> +   struct net_lim_cgroup *net_lim =
> +           css_net_lim(tsk->cgroups->subsys[net_lim_cgrp_id]);
> +   struct net_lim_range_item *walk;
> +   int found = 0;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   /* Don't apply cgroup rules if list is empty. */
> +   if (list_empty(&net_lim->port_ranges)) {
> +       found++;
> +       goto _unlock;
> +   }
> +   /* Check in list of ranges for allowed port. */
> +   list_for_each_entry(walk, &net_lim->port_ranges, list) {
> +       if ((walk->start <= port) && (port <= walk->end)) {
> +               found++;
> +               goto _unlock;
> +       }
> +   }
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +   return found;
> +}
> +
> +int net_lim_addr_allowed(struct task_struct *tsk, u32 addr)
> +{
> +   struct net_lim_cgroup *net_lim =
> +           css_net_lim(tsk->cgroups->subsys[net_lim_cgrp_id]);
> +   struct net_lim_addr_item *walk;
> +   int found = 0;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   /* Don't apply cgroup rules if list is empty. */
> +   if (list_empty(&net_lim->addrs)) {
> +       found++;
> +       goto _unlock;
> +   }
> +   /* Check in list of addrs for allowed addr. */
> +   list_for_each_entry(walk, &net_lim->addrs, list) {
> +       if (walk->addr == addr) {
> +           found++;
> +               goto _unlock;
> +       }
> +   }
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +   return found;
> +}
> +
> +void net_lim_get_local_port_range(struct task_struct *tsk, int *low, int *high)
> +{
> +   struct net_lim_cgroup *net_lim =
> +           css_net_lim(tsk->cgroups->subsys[net_lim_cgrp_id]);
> +   struct net_lim_range_item *range;
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   if (list_empty(&net_lim->port_ranges))
> +       goto _unlock;
> +
> +   /* Use net_lim range values if list of allowed ports is not empty. */
> +   range = list_last_entry(&net_lim->port_ranges,
> +                           struct net_lim_range_item, list);
> +
> +   *low = range->start;
> +   *high = range->end;
> +
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +}
> +
> +u32 net_lim_get_default_address(struct task_struct *tsk)
> +{
> +   struct net_lim_cgroup *net_lim =
> +           css_net_lim(tsk->cgroups->subsys[net_lim_cgrp_id]);
> +   u32 addr;
> +   struct net_lim_addr_item *addr_item;
> +
> +
> +   read_lock(&net_lim_croup_rwlock);
> +   if (list_empty(&net_lim->addrs)) {
> +       addr = 0;
> +       goto _unlock;
> +   }
> +
> +   /* Use net_lim range values if list of allowed ports is not empty. */
> +   addr_item = list_first_entry(&net_lim->addrs, struct net_lim_addr_item,
> +                                                   list);
> +   addr = addr_item->addr;
> +_unlock:
> +   read_unlock(&net_lim_croup_rwlock);
> +   return addr;
> +}
> diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
> index 9532ee8..e10ff09 100644
> --- a/net/ipv4/af_inet.c
> +++ b/net/ipv4/af_inet.c
> @@ -119,6 +119,9 @@
>  #include <linux/mroute.h>
>  #endif
>
> +#ifdef CONFIG_CGROUP_NET_LIM
> +#include <linux/net_lim_cgroup.h>
> +#endif
>
>  /* The inetsw table contains everything that inet_create needs to
>   * build a new socket.
> @@ -427,7 +430,12 @@ int inet_bind(struct socket *sock, struct
> sockaddr *uaddr, int addr_len)
>     unsigned short snum;
>     int chk_addr_ret;
>     int err;
> +#ifdef CONFIG_CGROUP_NET_LIM
> +   u32 def_addr = net_lim_get_default_address(get_current());
>
> +   if (def_addr != 0 && addr->sin_addr.s_addr == htonl(INADDR_ANY))
> +       addr->sin_addr.s_addr = def_addr;
> +#endif
>     /* If the socket has its own bind function then use it. (RAW) */
>     if (sk->sk_prot->bind) {
>         err = sk->sk_prot->bind(sk, uaddr, addr_len);
> @@ -467,6 +475,16 @@ int inet_bind(struct socket *sock, struct
> sockaddr *uaddr, int addr_len)
>
>     snum = ntohs(addr->sin_port);
>     err = -EACCES;
> +#ifdef CONFIG_CGROUP_NET_LIM
> +   // if (snum == 0 && !net_lim_zero_port_allowed(get_current()))
> +   //  goto out;
> +
> +   if (snum !=0 && !net_lim_port_allowed(get_current(), snum))
> +       goto out;
> +
> +   if (!net_lim_addr_allowed(get_current(), addr->sin_addr.s_addr))
> +       goto out;
> +#endif
>     if (snum && snum < PROT_SOCK &&
>         !ns_capable(net->user_ns, CAP_NET_BIND_SERVICE))
>         goto out;
> @@ -1834,4 +1852,3 @@ static int __init ipv4_proc_init(void)
>  #endif /* CONFIG_PROC_FS */
>
>  MODULE_ALIAS_NETPROTO(PF_INET);
> -
> diff --git a/net/ipv4/inet_connection_sock.c b/net/ipv4/inet_connection_sock.c
> index 60021d0..bb614d7 100644
> --- a/net/ipv4/inet_connection_sock.c
> +++ b/net/ipv4/inet_connection_sock.c
> @@ -6,6 +6,7 @@
>   *     Support for INET connection oriented protocols.
>   *
>   * Authors:    See the TCP sources
> + * TODO: ret
>   *
>   *     This program is free software; you can redistribute it and/or
>   *     modify it under the terms of the GNU General Public License
> @@ -24,6 +25,9 @@
>  #include <net/tcp_states.h>
>  #include <net/xfrm.h>
>  #include <net/tcp.h>
> +#ifdef CONFIG_CGROUP_NET_LIM
> +#include <linux/net_lim_cgroup.h>
> +#endif
>
>  #ifdef INET_CSK_DEBUG
>  const char inet_csk_timer_bug_msg[] = "inet_csk BUG: unknown timer value\n";
> @@ -40,6 +44,10 @@ void inet_get_local_port_range(struct net *net, int
> *low, int *high)
>         *low = net->ipv4.ip_local_ports.range[0];
>         *high = net->ipv4.ip_local_ports.range[1];
>     } while (read_seqretry(&net->ipv4.ip_local_ports.lock, seq));
> +#ifdef CONFIG_CGROUP_NET_LIM
> +   net_lim_get_local_port_range(get_current(), low, high);
> +#endif
> +
>  }
>  EXPORT_SYMBOL(inet_get_local_port_range);
> --
> 2.1.0
>
>
> ---
> WBR,
> Dmitry
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
