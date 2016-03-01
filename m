From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv8 2/3] IB/core: added support to use rdma cgroup controller
Date: Tue, 1 Mar 2016 22:47:41 +0530
Message-ID: <CAG53R5UWSxd4PLg_2sPGNxA0Q4busnEk_jjXYtmToWy8n25vNQ@mail.gmail.com>
References: <1456842400-29528-3-git-send-email-pandit.parav@gmail.com>
	<201603012333.XqMypLgI%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc;
        bh=XUHk9YclNDbXVbj2CMLlvO+2Neo5EVXsD7dtfVmSzHw=;
        b=SHD/l0KI1dVitneM9OFz5XT2p4lt+fhGdmE+k95eD2BU0SmZjnqoa6eaWOwj107rsz
         d3gKsrP3qeW/6Yp/8Y/i/mukNicK+cBFZ6RFzJeRESe2UDGzcgtOLa/z4p0z9aNTpTCW
         EKWetjn/05qpesmE2Du5YngLty+qxjl32WThrVcjJBa99GxOHeqNY797cD79XiiToWos
         aORjhgqO+GttCe8ZlwJqRzicsn5Jb6v20atuvRJKH/v+yiz06mq0+JDiSHA82gadJ6ik
         2niSb001OxNksDIhXOkaF1XKsT91SvgP+avSUmYf5HZvIHJyfP2Xi80WhzRNop4tjqxb
         LTUA==
In-Reply-To: <201603012333.XqMypLgI%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Sorry. My bad. Generated patch in hurry for compiled out code in ifdef.
Sending with fixing compilation.

Parav

On Tue, Mar 1, 2016 at 9:20 PM, kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Hi Parav,
>
> [auto build test ERROR on rdma/master]
> [also build test ERROR on v4.5-rc6 next-20160301]
> [if your patch is applied to the wrong git tree, please drop us a note to help improving the system]
>
> url:    https://github.com/0day-ci/linux/commits/Parav-Pandit/rdmacg-IB-core-rdma-controller-support/20160301-223149
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma master
> config: x86_64-allmodconfig (attached as .config)
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=x86_64
>
> All error/warnings (new ones prefixed by >>):
>
>    include/linux/compiler.h:228:8: sparse: attribute 'no_sanitize_address': unknown attribute
>    drivers/infiniband/core/cgroup.c:107:6: sparse: symbol 'ib_rdmacg_query_limit' redeclared with different type (originally declared at drivers/infiniband/core/core_priv.h:140) - different argument counts
>>> drivers/infiniband/core/cgroup.c:107:6: error: conflicting types for 'ib_rdmacg_query_limit'
>     void ib_rdmacg_query_limit(struct ib_device *device, int *limits)
>          ^
>    In file included from drivers/infiniband/core/cgroup.c:35:0:
>    drivers/infiniband/core/core_priv.h:140:6: note: previous declaration of 'ib_rdmacg_query_limit' was here
>     void ib_rdmacg_query_limit(struct ib_device *device,
>          ^
>    In file included from include/linux/linkage.h:6:0,
>                     from include/linux/kernel.h:6,
>                     from drivers/infiniband/core/cgroup.c:31:
>    drivers/infiniband/core/cgroup.c:111:15: error: conflicting types for 'ib_rdmacg_query_limit'
>     EXPORT_SYMBOL(ib_rdmacg_query_limit);
>                   ^
>    include/linux/export.h:57:21: note: in definition of macro '__EXPORT_SYMBOL'
>      extern typeof(sym) sym;     \
>                         ^
>>> drivers/infiniband/core/cgroup.c:111:1: note: in expansion of macro 'EXPORT_SYMBOL'
>     EXPORT_SYMBOL(ib_rdmacg_query_limit);
>     ^
>    In file included from drivers/infiniband/core/cgroup.c:35:0:
>    drivers/infiniband/core/core_priv.h:140:6: note: previous declaration of 'ib_rdmacg_query_limit' was here
>     void ib_rdmacg_query_limit(struct ib_device *device,
>          ^
>
> sparse warnings: (new ones prefixed by >>)
>
>    include/linux/compiler.h:228:8: sparse: attribute 'no_sanitize_address': unknown attribute
>>> drivers/infiniband/core/uverbs_cmd.c:470:30: sparse: not enough arguments for function ib_rdmacg_query_limit
>    drivers/infiniband/core/uverbs_cmd.c:3721:30: sparse: not enough arguments for function ib_rdmacg_query_limit
>    drivers/infiniband/core/uverbs_cmd.c: In function 'ib_uverbs_query_device':
>    drivers/infiniband/core/uverbs_cmd.c:470:2: error: too few arguments to function 'ib_rdmacg_query_limit'
>      ib_rdmacg_query_limit(ib_dev, limits);
>      ^
>    In file included from drivers/infiniband/core/uverbs_cmd.c:44:0:
>    drivers/infiniband/core/core_priv.h:140:6: note: declared here
>     void ib_rdmacg_query_limit(struct ib_device *device,
>          ^
>    drivers/infiniband/core/uverbs_cmd.c: In function 'ib_uverbs_ex_query_device':
>    drivers/infiniband/core/uverbs_cmd.c:3721:2: error: too few arguments to function 'ib_rdmacg_query_limit'
>      ib_rdmacg_query_limit(ib_dev, limits);
>      ^
>    In file included from drivers/infiniband/core/uverbs_cmd.c:44:0:
>    drivers/infiniband/core/core_priv.h:140:6: note: declared here
>     void ib_rdmacg_query_limit(struct ib_device *device,
>          ^
>
> vim +/ib_rdmacg_query_limit +107 drivers/infiniband/core/cgroup.c
>
>     25   * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
>     26   * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
>     27   * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
>     28   * SOFTWARE.
>     29   */
>     30
>   > 31  #include <linux/kernel.h>
>     32  #include <linux/cgroup_rdma.h>
>     33  #include <linux/parser.h>
>     34
>     35  #include "core_priv.h"
>     36
>     37  /**
>     38   * resource table definition as to be seen by the user.
>     39   * Need to add entries to it when more resources are
>     40   * added/defined at IB verb/core layer.
>     41   */
>     42  static char const *resource_tokens[] = {
>     43          [RDMA_VERB_RESOURCE_UCTX] = "uctx",
>     44          [RDMA_VERB_RESOURCE_AH] = "ah",
>     45          [RDMA_VERB_RESOURCE_PD] = "pd",
>     46          [RDMA_VERB_RESOURCE_CQ] = "cq",
>     47          [RDMA_VERB_RESOURCE_MR] = "mr",
>     48          [RDMA_VERB_RESOURCE_MW] = "mw",
>     49          [RDMA_VERB_RESOURCE_SRQ] = "srq",
>     50          [RDMA_VERB_RESOURCE_QP] = "qp",
>     51          [RDMA_VERB_RESOURCE_FLOW] = "flow",
>     52  };
>     53
>     54  /**
>     55   * ib_device_register_rdmacg - register with rdma cgroup.
>     56   * @device: device to register to participate in resource
>     57   *          accounting by rdma cgroup.
>     58   *
>     59   * Register with the rdma cgroup. Should be called before
>     60   * exposing rdma device to user space applications to avoid
>     61   * resource accounting leak.
>     62   * HCA drivers should set resource pool ops first if they wish
>     63   * to support hw specific resource accounting before IB core
>     64   * registers with rdma cgroup.
>     65   * Returns 0 on success or otherwise failure code.
>     66   */
>     67  int ib_device_register_rdmacg(struct ib_device *device)
>     68  {
>     69          device->cg_device.name = device->name;
>     70          device->cg_device.pool_info.resource_name_table = resource_tokens;
>     71          device->cg_device.pool_info.table_len = ARRAY_SIZE(resource_tokens);
>     72          return rdmacg_register_device(&device->cg_device);
>     73  }
>     74
>     75  /**
>     76   * ib_device_unregister_rdmacg - unregister with rdma cgroup.
>     77   * @device: device to unregister.
>     78   *
>     79   * Unregister with the rdma cgroup. Should be called after
>     80   * all the resources are deallocated, and after a stage when any
>     81   * other resource allocation of user application cannot be done
>     82   * for this device to avoid any leak in accounting.
>     83   */
>     84  void ib_device_unregister_rdmacg(struct ib_device *device)
>     85  {
>     86          rdmacg_unregister_device(&device->cg_device);
>     87  }
>     88
>     89  int ib_rdmacg_try_charge(struct ib_rdmacg_object *cg_obj,
>     90                           struct ib_device *device,
>     91                           int resource_index, int num)
>     92  {
>     93          return rdmacg_try_charge(&cg_obj->cg, &device->cg_device,
>     94                                   resource_index, num);
>     95  }
>     96  EXPORT_SYMBOL(ib_rdmacg_try_charge);
>     97
>     98  void ib_rdmacg_uncharge(struct ib_rdmacg_object *cg_obj,
>     99                          struct ib_device *device,
>    100                          int resource_index, int num)
>    101  {
>    102          rdmacg_uncharge(cg_obj->cg, &device->cg_device,
>    103                          resource_index, num);
>    104  }
>    105  EXPORT_SYMBOL(ib_rdmacg_uncharge);
>    106
>  > 107  void ib_rdmacg_query_limit(struct ib_device *device, int *limits)
>    108  {
>    109          rdmacg_query_limit(&device->cg_device, limits);
>    110  }
>  > 111  EXPORT_SYMBOL(ib_rdmacg_query_limit);
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
