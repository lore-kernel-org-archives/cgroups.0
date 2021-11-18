From: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH RFC 2/4] bpf,
 perf: add ability to attach complete array of bpf prog to perf event
Date: Thu, 18 Nov 2021 15:28:38 -0500
Message-ID: <20211118202840.1001787-3-Kenny.Ho@amd.com>
References: <20211118202840.1001787-1-Kenny.Ho@amd.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9LTCxDJv3hxoUKuAs/bDMtp2aWzOrmYrLj1GHD61d7s=;
 b=ApN7FpnWJgqBMOzvj8slk3X08GPp57/v2+cNanaKEgPqjegxvtz3347IPTRrSvrek4f4tL/M5DmZnjC/TFa9HHUAooH40Fo78JPeZERa+z77stRYrNwE26g2gnjX+RQsXBtkab95HUWPTk5ZtbuIsM0SOhOO1NFA5WwS0O+CytY=
In-Reply-To: <20211118202840.1001787-1-Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.freedesktop.org/mailman/options/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.freedesktop.org/archives/amd-gfx>
List-Post: <mailto:amd-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
List-Help: <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=help>
List-Subscribe: <https://lists.freedesktop.org/mailman/listinfo/amd-gfx>,
 <mailto:amd-gfx-request-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org?subject=subscribe>
Errors-To: amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
Sender: "amd-gfx" <amd-gfx-bounces-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>
Content-Type: text/plain; charset="us-ascii"
To: Alexei Starovoitov <ast-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>, Andrii Nakryiko <andrii-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin KaFai Lau <kafai-b10kYP2dOMg@public.gmane.org>, Song Liu <songliubraving-b10kYP2dOMg@public.gmane.org>, Yonghong Song <yhs-b10kYP2dOMg@public.gmane.org>, John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KP Singh <kpsingh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes
 Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo
 Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark
 Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jiri Olsa <jolsa-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Namhyung
 Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-perf-users-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, y2kenny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Kenny.Ho@amd

Change-Id: Ie2580c3a71e2a5116551879358cb5304b04d3838
Signed-off-by: Kenny Ho <Kenny.Ho-5C7GfCeVMHo@public.gmane.org>
---
 include/linux/trace_events.h |  9 +++++++++
 kernel/trace/bpf_trace.c     | 28 ++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/trace_events.h b/include/linux/trace_events.h
index 3e475eeb5a99..5cfe3d08966c 100644
--- a/include/linux/trace_events.h
+++ b/include/linux/trace_events.h
@@ -725,6 +725,8 @@ trace_trigger_soft_disabled(struct trace_event_file *file)
 
 #ifdef CONFIG_BPF_EVENTS
 unsigned int trace_call_bpf(struct trace_event_call *call, void *ctx);
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array);
 int perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog, u64 bpf_cookie);
 void perf_event_detach_bpf_prog(struct perf_event *event);
 int perf_event_query_prog_array(struct perf_event *event, void __user *info);
@@ -741,6 +743,13 @@ static inline unsigned int trace_call_bpf(struct trace_event_call *call, void *c
 	return 1;
 }
 
+static inline int
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int
 perf_event_attach_bpf_prog(struct perf_event *event, struct bpf_prog *prog, u64 bpf_cookie)
 {
diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6b3153841a33..8addd10202c2 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1802,6 +1802,34 @@ static DEFINE_MUTEX(bpf_event_mutex);
 
 #define BPF_TRACE_MAX_PROGS 64
 
+int perf_event_attach_bpf_prog_array(struct perf_event *event,
+				     struct bpf_prog_array *new_array)
+{
+	struct bpf_prog_array_item *item;
+	struct bpf_prog_array *old_array;
+
+	if (!new_array)
+		return -EINVAL;
+
+	if (bpf_prog_array_length(new_array) >= BPF_TRACE_MAX_PROGS)
+		return -E2BIG;
+
+	if (!trace_kprobe_on_func_entry(event->tp_event) ||
+	     !trace_kprobe_error_injectable(event->tp_event))
+		for (item = new_array->items; item->prog; item++)
+			if (item->prog->kprobe_override)
+				return -EINVAL;
+
+	mutex_lock(&bpf_event_mutex);
+
+	old_array = bpf_event_rcu_dereference(event->tp_event->prog_array);
+	rcu_assign_pointer(event->tp_event->prog_array, new_array);
+	bpf_prog_array_free(old_array);
+
+	mutex_unlock(&bpf_event_mutex);
+	return 0;
+}
+
 int perf_event_attach_bpf_prog(struct perf_event *event,
 			       struct bpf_prog *prog,
 			       u64 bpf_cookie)
-- 
2.25.1

