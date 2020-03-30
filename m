From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2] docs: cgroup-v1: Document the cpuset_v2_mode mount
 option
Date: Mon, 30 Mar 2020 10:07:31 -0400
Message-ID: <1b25bc58-b916-660f-090a-1a1f13a4656d@redhat.com>
References: <20200330140615.25549-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1585577257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9LrxmkAvaSght2/9QdSVfP4wqkPdT52lYY1qjr1mVKY=;
        b=PbKDIEzBD1jaRxQUrYwn9MXzfNbJuHtnasoiRH5AfseJ7aJXIDy1e+NA3q4BPbPiJ24n+C
        eQAWj7hniPjTYL2CFKGinrQOaZNLmDDqF8X5mGkYESBV1DPy8bpOipVhS/qHJDswvZUNBf
        KBw2KRSzKlBkrrCB1SZC/oQqqJKjlW0=
In-Reply-To: <20200330140615.25549-1-longman@redhat.com>
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, Sonny Rao <sonnyrao@google.com>

On 3/30/20 10:06 AM, Waiman Long wrote:
> The cpuset in cgroup v1 accepts a special "cpuset_v2_mode" mount
> option that make cpuset.cpus and cpuset.mems behave more like those in
> cgroup v2.  Document it to make other people more aware of this feature
> that can be useful in some circumstances.
>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  Documentation/admin-guide/cgroup-v1/cpusets.rst | 11 +++++++++++
>  kernel/cgroup/cpuset.c                          |  8 ++++++--
>  2 files changed, 17 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> index 86a6ae995d54..7ade3abd342a 100644
> --- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
> @@ -223,6 +223,17 @@ cpu_online_mask using a CPU hotplug notifier, and the mems file
>  automatically tracks the value of node_states[N_MEMORY]--i.e.,
>  nodes with memory--using the cpuset_track_online_nodes() hook.
>  
> +The cpuset.effective_cpus and cpuset.effective_mems files are
> +normally read-only copies of cpuset.cpus and cpuset.mems files
> +respectively.  If the cpuset cgroup filesystem is mounted with the
> +special "cpuset_v2_mode" option, the behavior of these files will become
> +similar to the corresponding files in cpuset v2.  In other words, hotplug
> +events will not change cpuset.cpus and cpuset.mems.  Those events will
> +only affect cpuset.effective_cpus and cpuset.effective_mems which show
> +the actual cpus and memory nodes that are currently used by this cpuset.
> +See Documentation/admin-guide/cgroup-v2.rst for more information about
> +cpuset v2 behavior.
> +
>  
>  1.4 What are exclusive cpusets ?
>  --------------------------------
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58f5073acff7..729d3a5c772e 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -358,8 +358,12 @@ static DECLARE_WORK(cpuset_hotplug_work, cpuset_hotplug_workfn);
>  static DECLARE_WAIT_QUEUE_HEAD(cpuset_attach_wq);
>  
>  /*
> - * Cgroup v2 behavior is used when on default hierarchy or the
> - * cgroup_v2_mode flag is set.
> + * Cgroup v2 behavior is used on the "cpus" and "mems" control files when
> + * on default hierarchy or when the cpuset_v2_mode flag is set by mounting
> + * the v1 cpuset cgroup filesystem with the "cpuset_v2_mode" mount option.
> + * With v2 behavior, "cpus" and "mems" are always what the users have
> + * requested and won't be changed by hotplug events. Only the effective
> + * cpus or mems will be affected.
>   */
>  static inline bool is_in_v2_mode(void)
>  {

On second thought, I should have clarified the cpuset_v2_mode option in
the cpuset.c file itself also.

Cheers,
Longman

